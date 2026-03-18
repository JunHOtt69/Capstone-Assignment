const dropZone = document.querySelector('.dropZone');
const fileInput = document.getElementById('file-input');
const previewSection = document.getElementById('previewSection');
const tableBody = document.getElementById('tableBody');
const tableHeaderRow = document.querySelector('thead tr');
const clearFileBtn = document.getElementById('clearFile');
const submitBtn = document.getElementById('submitBtn');
const errorMessageContainer = document.querySelector('.errorMessage');
errorMessageContainer.innerHTML = '';
previewSection.classList.add('hidden');
dropZone.classList.remove('hidden');
const loading = document.querySelector('.loading');
loading.classList.remove('active');
let parsedUserData = [];
const REQUIRED_FIELDS = ['first_name', 'last_name', 'email', 'role'];

dropZone.addEventListener('click', () => fileInput.click());


['dragover', 'dragleave', 'drop'].forEach(eventName => {
    dropZone.addEventListener(eventName, (e) => {
        e.preventDefault();
        e.stopPropagation();
    });
});

dropZone.addEventListener('dragover', () => dropZone.classList.add('active'));
dropZone.addEventListener('dragleave', () => dropZone.classList.remove('active'));

dropZone.addEventListener('drop', (e) => {
    dropZone.classList.remove('active');
    
    const files = e.dataTransfer.files;
    if (files.length > 0) handleFile(files[0]);
});

fileInput.addEventListener('change', (e) => {
    if (e.target.files.length > 0) handleFile(e.target.files[0]);
});

function handleFile(file) {
    if (file.type !== "text/csv" && !file.name.endsWith('.csv')) {
        alert("Please upload a valid CSV file.");
        return;
    }
    
    Papa.parse(file, {
        header: true,
        skipEmptyLines: true,
        complete: function(results) {
            const uploadedFields = Object.keys(results.data[0]);
            const missingFields = REQUIRED_FIELDS.filter(field => !uploadedFields.includes(field));

            if(missingFields.length > 0){
                const err = document.createElement('p');
                err.textContent = `Error: Missing required columns: ${missingFields.join(', ')}`;
                errorMessageContainer.appendChild(err);
                clearFileBtn.click();
                return;
            }

            dropZone.classList.add('hidden');
            parsedUserData = results.data;
            displayPreview(results.data);
            errorMessageContainer.innerHTML = '';
        }
    });
}

function displayPreview(data) {
    tableBody.innerHTML = '';
    const headers = Object.keys(data[0]);
    
    tableHeaderRow.innerHTML = '<th class="no-col">No.</th>'; 
    headers.forEach(header => {
        const th = document.createElement('th');
        th.textContent = header;
        tableHeaderRow.appendChild(th);
    });

    const previewData = data.slice(0, 5);
    previewData.forEach((row, index) => {
        const tr = document.createElement('tr');
        
        const tdNum = document.createElement('td');
        tdNum.className = 'number-cell';
        tr.appendChild(tdNum);

        headers.forEach(header => {
            const td = document.createElement('td');
            td.textContent = row[header] || '-';
            tr.appendChild(td);
        });

        tableBody.appendChild(tr);
    });

    previewSection.classList.remove('hidden');
}

clearFileBtn.addEventListener('click', () => {
    previewSection.classList.add('hidden');
    dropZone.classList.remove('hidden');
    fileInput.value = '';
    parsedUserData = [];
    
});


submitBtn.addEventListener('click', function(e) {
    e.preventDefault();

    if (parsedUserData.length === 0) {
        return alert("Please upload a file first.");
    }

    errorMessageContainer.innerHTML = '';
    
    const emails = parsedUserData.map(row => row.email).filter(email => email);

    const params = new URLSearchParams();
    emails.forEach(email => params.append('emails[]', email));

    loading.classList.add('active');
    
    fetch(`/check-email/?${params.toString()}`)
        .then(response => response.json())
        .then(data => {
            if (data.is_taken) {
                const err = document.createElement('p');
                err.textContent = "The following emails already exist in the system:";
                errorMessageContainer.appendChild(err);
                data.taken_emails.forEach(item => {
                    const err = document.createElement('p');
                    err.textContent= `- Row ${item.index}: ${item.email}\n`;
                    errorMessageContainer.appendChild(err);
                    loading.classList.remove('active');
                });
            } else {
                const dataInput = document.getElementById('userDataInput');
                const form = document.getElementById('bulkCreateForm');

                const cleanData = parsedUserData.map(row => ({
                    first_name: row.first_name || '',
                    last_name: row.last_name || '',
                    email: row.email || '',
                    role: row.role || '',
                    department: row.department || '',
                    intake: row.intake || ''
                }));

                dataInput.value = JSON.stringify(cleanData);

                // console.log("Final Json string", dataInput.value);
                form.submit();
            }
        })
        .catch(err => alert("Error checking emails: " + err));
});