const searchInput = document.querySelector('.searchBar input');
const userRoleContainer = document.getElementById('user_role');
const tableContainer = document.querySelector('.crud');
const userList = document.getElementById('user-table');
let original_email;

searchInput.addEventListener('input', function() {
    const query = this.value;
    const role = userRoleContainer.getAttribute('data-role');

    fetch(`/user/crud/?q=${query}&role=${role}`, {
        headers: { 'X-Requested-With': 'XMLHttpRequest' }
    })
    .then(response => response.text())
    .then(html => {
        document.getElementById('user-table').outerHTML = html;
    })
    .catch(err => console.warn('Search error:', err));
});

function openEditModal(userId) {
    const wrapper = document.querySelector('.editTableWrapper');
    const role = document.getElementById('user_role').getAttribute('data-role');
    document.getElementById('edit-user-id').value = userId;

    fetch(`/get-details/${userId}/`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('edit-first-name').value = data.first_name;
            document.getElementById('edit-last-name').value = data.last_name;
            document.getElementById('edit-email').value = data.email;
            original_email = data.email;
            
            if (data.role === 'lecturer' && data.dept_id) {
                const radio = document.querySelector(`input[value="${data.dept_id}"]`);
                if (radio) {
                    radio.checked = true;
                    radio.closest('.selectInput').querySelector('.selectedLabel label').textContent = data.dept_name;
                }
            } else if (data.role === 'student' && data.intake_id) {
                const radio = document.querySelector(`input[value="${data.intake_id}"]`);
                if (radio) {
                    radio.checked = true;
                    radio.closest('.selectInput').querySelector('.selectedLabel label').textContent = data.intake_code;
                }
            }

            wrapper.classList.add('editing');
            
            userList.classList.add('hidden');
            wrapper.setAttribute('data-editing-id', userId);
        })
        .catch(err => console.error("Error loading user:", err));
}

const cancelBtn = document.getElementById('cancelUser');
const saveBtn = document.getElementById('saveUser');
const dltBtn = document.getElementById('dltUser');

cancelBtn.addEventListener('click', () => {
    if (confirm("Are you sure? All unsaved changes will be discarded.")) {
        const wrapper = document.querySelector('.editTableWrapper');
        wrapper.classList.remove('editing');
        userList.classList.remove('hidden');
        wrapper.querySelectorAll('input[type="text"], input[type="email"]').forEach(input => input.value = '');
    }
});

dltBtn.addEventListener('click', function(event) {
    const confirmed = confirm("CRITICAL: This action cannot be undone. Are you sure you want to delete this user?");
    
    if (confirmed) {
        document.getElementById('form-action').value = 'delete';
    }else{
        event.preventDefault();
    }
});

saveBtn.addEventListener('click', async function(event) {
    event.preventDefault();
    const messageContainer = document.querySelector('.errorMessage');
    messageContainer.innerHTML = ''; 
    const errors = [];

    const firstName = document.getElementById('edit-first-name').value.trim();
    const lastName = document.getElementById('edit-last-name').value.trim();
    const email = document.getElementById('edit-email').value.trim();
    const role = document.getElementById('user_role').getAttribute('data-role');
    
    const extraIdInput = document.querySelector('input[name="extra_id"]:checked');
    const extraId = extraIdInput ? extraIdInput.value : null;

    if (!firstName || !lastName || !email) {
        errors.push("Name and Email fields cannot be empty.");
    }
    if (!email.includes('@')) {
        errors.push("Please enter a valid email address.");
    }
    if (role !== 'admin' && !extraId) {
        const type = role === 'lecturer' ? "Department" : "Intake Term";
        errors.push(`Please select a ${type}.`);
    }

    if(errors.length === 0 && email !== original_email){
        const params = new URLSearchParams();
        params.append('emails[]', email);
        try{
            const response = await fetch(`/check-email/?${params.toString()}`);
            const data = await response.json();
            
            if(data.is_taken){
                data.taken_emails.forEach(item => {
                    errors.push(`The email ${email} is already registered.`)
                });
            }

        } catch(error){
            console.error('validation failed: ', error);
            errors.push(`An error occurred during validation. Please try again.`)
        }
    }

    if(errors.length > 0){
        errors.forEach(error => {
            const errorMessage = document.createElement('p');
            errorMessage.innerHTML = error;
            messageContainer.appendChild(errorMessage);
        })
    }else{
        const loading = document.querySelector('.loading');
        loading.classList.add('active');
        document.querySelector(".editTableWrapper").submit();
    }
});


const editWrapper = document.querySelector('.editTableWrapper');
if (editWrapper) {
    editWrapper.addEventListener('click', (event) => {
        const label = event.target.closest('.selectedLabel');
        if (label) {
            const parentSelect = label.closest('.selectInput');
            parentSelect.classList.toggle('active');
        }
    });

    editWrapper.addEventListener('change', (event) => {
        if (event.target.type === 'radio' && event.target.name === 'extra_id') {
            const parentSelect = event.target.closest('.selectInput');
            console.log("changes");
            console.log(parentSelect);
            const chosenText = event.target.nextElementSibling.innerText;
            
            parentSelect.querySelector('.selectedLabel label').innerText = chosenText;
            
            parentSelect.classList.remove('active');
        }
    });

    document.addEventListener('click', (event) => {
        if (!event.target.closest('.selectInput')) {
            document.querySelectorAll('.selectInput.active').forEach(el => {
                el.classList.remove('active');
            });
        }
    });
}