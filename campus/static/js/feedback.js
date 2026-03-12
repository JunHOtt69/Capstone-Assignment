let isSubmitting = false;
let initialData = {};

document.addEventListener("DOMContentLoaded", async function() {
    const quill = new Quill('#editor', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ 'size': ['small', false, 'large', 'huge'] }],
                ['bold', 'italic', 'underline'],
                [{ 'list': 'ordered'}, { 'list': 'bullet' }],
                ['link', 'image'],
            ]
        },
        placeholder: 'Explain the issue in detail. You can paste screenshots or use the formatting tools below.',
        formats: [
            'size', 
            'bold', 'italic', 'underline', 
            'list', 
            'link', 'image'
        ]
    });

    const hiddenContent = document.querySelector('#id_description').value;
    if (hiddenContent && hiddenContent.trim() !== "") {
        quill.root.innerHTML = hiddenContent;
    }else {
        quill.setContents([]); 
    }

    const contentInput = document.querySelector('#id_description');
    quill.on('text-change', function() {
        const html = quill.root.innerHTML;
        contentInput.value = html;
    });


    const categorySelect = document.getElementById('categorySelect');
    const selectedLabel = categorySelect.querySelector('.selectedLabel label');
    const realCategoryInput = document.querySelector('input[name="category"][type="hidden"]'); 
    const options = document.querySelectorAll('.option input[type="radio"]');
    const titleInput = document.querySelector('#id_title');
    const suggestionsList = document.getElementById('faqSuggestions');

    let suggestionRequestId = 0;

    categorySelect.addEventListener('click', (e) => {
        categorySelect.classList.toggle('active');
        e.stopPropagation();
    });

    document.addEventListener('click', (e) => {
        if(!categorySelect.contains(e.target)){
            categorySelect.classList.remove('active');
        }
        if(!titleInput.contains(e.target)){
            suggestionsList.classList.toggle('visible', false);
        }
    });

    options.forEach(opt => {
        opt.addEventListener('change', () => {
            const labelText = opt.nextElementSibling.innerText;
            selectedLabel.innerText = labelText;
            
            if(realCategoryInput) realCategoryInput.value = opt.value;
            
            categorySelect.classList.remove('active');
            
            const categoryerr = document.getElementById('categoryerr');

            categoryerr.innerHTML = ``;
            categoryerr.classList.toggle('hide', true);

            const query = document.querySelector('#id_title').value.trim();
            fetchSuggestions(query);
        });
    });

    const fetchSuggestions = async (query) => {
        const requestId = ++suggestionRequestId;
        
        const selectedCategory = document.querySelector('input[name="category"]:checked')?.value || "";

        try {
            const response = await fetch(`/suggestions/?q=${encodeURIComponent(query)}&cat=${encodeURIComponent(selectedCategory)}`);
            const data = await response.json();
            if (requestId !== suggestionRequestId) return;

            renderSuggestions(data.suggestions || []);
        } catch (error) {
            console.error("Fetch error:", error);
            suggestionsList.innerHTML = '';
            suggestionsList.classList.remove('visible');
        }
    };

    titleInput.addEventListener('click', () => {
        suggestionsList.classList.toggle('visible', true);
    });

    titleInput.addEventListener('input', (event) => {
        const query = event.target.value.trim();

        if (query.length < 2) {
            suggestionsList.innerHTML = '';
            // hideSuggestions();
            return;
        }
        
        fetchSuggestions(query);
    });

    titleInput.addEventListener('keydown', (event) => {
        const selectedCategory = document.querySelector('input[name="category"]:checked')?.value || "";
        const categoryerr = document.getElementById('categoryerr');

        if(selectedCategory === '' && event.key != 'Tab' && event.key != 'Backspace'){
            event.preventDefault();
            categoryerr.innerHTML = `
                <p class="error">Please Select a category to continue!</p>
            `;
            categoryerr.classList.toggle('hide', false);
        }

        if (event.key !== 'Enter') {
            return;
        }

        if (suggestionsList.classList.contains('visible') && activeSuggestionHref) {
            event.preventDefault();
            window.location.href = activeSuggestionHref;
        }
    });

    const renderSuggestions = (suggestions) => {
        suggestionsList.innerHTML = '';
        activeSuggestionHref = null;

        if (suggestions.length > 0) {
            suggestionsList.innerHTML = `
                <p>Related FAQ Suggestions:</p>
            `;
            suggestions.forEach((item, index) => {
                const suggestion = document.createElement('a');
                suggestion.className = 'suggestion';
                suggestion.href = `/FAQs/${item.slug}/?from_click=1`;
                suggestion.target = "_blank";

                if(index === 0){
                    activeSuggestionHref = suggestion.href;
                }

                suggestion.innerHTML = `
                    <p class="suggestionTitle">${item.title}</p>
                `;
                suggestionsList.appendChild(suggestion);
            });
            suggestionsList.classList.add('visible');
        } else {
            suggestionsList.classList.remove('visible');
        }
    };

    const uploadBox = document.querySelector('.uploadBox');
    const fileInput = document.querySelector('input[type="file"]');
    const fileCardList = document.querySelector('.fileCardList');
    const uploadPrompt = uploadBox.querySelector('p');
    const fileError = document.getElementById('fileerr');
    let masterFileList = [];

    uploadBox.addEventListener('click', () => fileInput.click());

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        uploadBox.addEventListener(eventName, (e) => {
            e.preventDefault();
            e.stopPropagation();
        }, false);
    });

    ['dragenter', 'dragover'].forEach(eventName => {
        uploadBox.addEventListener(eventName, () => {
            uploadBox.classList.add('drag-active');
        }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        uploadBox.addEventListener(eventName, () => {
            uploadBox.classList.remove('drag-active');
        }, false);
    });

    uploadBox.addEventListener('drop', (e) => {
        const droppedFiles = e.dataTransfer.files;
        if (droppedFiles.length > 0) {
            fileInput.files = droppedFiles;
            fileInput.dispatchEvent(new Event('change'));
        }
    });

    fileInput.addEventListener('change', function() {
        const newFiles = Array.from(this.files || []);
        if (newFiles.length === 0) return; 
        
        
        const allowedExtensions = ['PDF', 'DOCX', 'XLSX', 'PNG', 'JPG', 'JPEG', 'MP4', 'MOV', 'RAR'];

        const validNewFiles = [];
        const invalidExtensions = [];

        newFiles.forEach(file => {
            const ext = file.name.split('.').pop().toUpperCase();
            if (allowedExtensions.includes(ext)) {
                validNewFiles.push(file);
            } else {
                invalidExtensions.push(file.name);
            }
        });

        if (invalidExtensions.length > 0) {
            fileError.innerHTML = `<p class="error">Unsupported file type: ${invalidExtensions.join(', ')}. Please use PDF, Office, or Media files.</p>`;
            fileError.classList.remove('hide');
            
            const dt = new DataTransfer();
            masterFileList.forEach(f => dt.items.add(f));
            fileInput.files = dt.files;
            return;
        }

        const allFiles = [...masterFileList, ...newFiles];
        if (allFiles.length > 5) {
            fileError.innerHTML = `<p class="error">You can only upload a maximum of 5 files.</p>`;
            fileError.classList.remove('hide');

            const dt = new DataTransfer();
            masterFileList.forEach(f => dt.items.add(f));
            fileInput.files = dt.files;
            return;
        }

        masterFileList = allFiles;

        const finalDt = new DataTransfer();
        allFiles.forEach(f => finalDt.items.add(f));
        fileInput.files = finalDt.files;

        renderFileCards();
    });

    function renderFileCards(){
        fileCardList.innerHTML = ''; 
        fileCardList.classList.remove('hide');
        uploadPrompt.classList.add('hide');
        fileError.classList.add('hide');

        if (fileInput.files.length > 0) {
            Array.from(fileInput.files).forEach((file, index) => {
                let extension = file.name.split('.').pop().toUpperCase();
                if(extension === 'JPEG') extension = 'JPG';
                const fileSize = (file.size / 1024).toFixed(1) + ' KB';
                
                const card = document.createElement('div');
                card.className = 'fileCard';
                card.innerHTML = `
                    <span class="fileIcon">
                        <img src="/media/file_icons/${extension}.svg" onerror="this.src='/media/file_icons/GENERIC.svg'">
                    </span>
                    <div class="fileDetailWrapper">
                        <p class="fileName">${file.name}</p>
                        <p class="fileSize">${fileSize}</p>
                    </div>
                `;

                const deleteBtn = document.createElement('div');
                deleteBtn.className = 'deleteFile';
                deleteBtn.dataset.index = index;
                deleteBtn.innerHTML = `
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
                    </svg>
                `;

                card.appendChild(deleteBtn);
                fileCardList.appendChild(card);
            });
        } else {
            fileCardList.classList.add('hide');
            uploadPrompt.classList.remove('hide');
        }
    }

    fileCardList.addEventListener('click', function(e) {
        e.stopPropagation();
        const btn = e.target.closest('.deleteFile');
        if (!btn) return;

        const indexToRemove = parseInt(btn.dataset.index);
        masterFileList.splice(indexToRemove, 1);

        const dt = new DataTransfer();
        masterFileList.forEach(file => dt.items.add(file));
        fileInput.files = dt.files;

        renderFileCards();
    });


    const cancelBtn = document.querySelector('.cancel');
    const submitBtn = document.querySelector('.submit');
    cancelBtn.addEventListener('click', (e) => {
        e.preventDefault(); 
        const confirmCancel = confirm("Are you sure you want to discard this feedback? Your changes will not be saved.");
        if (confirmCancel) {
            window.location.href = '/FAQs/'; 
        }
    });

    submitBtn.addEventListener('click', (e) => {
        const categoryValue = document.querySelector('input[name="category"]').value;
        const titleValue = document.querySelector('#id_title').value.trim();
        
        const descriptionText = quill.getText().trim(); 
        const categoryerr = document.getElementById('categoryerr');

        let errors = [];

        if (!categoryValue || categoryValue === "") {
            errors.push("Please select a Support Category.");
        }

        if (titleValue.length < 5) {
            errors.push("Please provide a more descriptive Issue Summary (min 5 characters).");
        }

        if (descriptionText.length < 10) {
            errors.push("Please provide a detailed description of at least 10 characters.");
        }

        if (errors.length > 0) {
            e.preventDefault();
            categoryerr.innerHTML = `<p class="error">${errors[0]}</p>`;
            categoryerr.classList.remove('hide');
            
            categoryerr.scrollIntoView({ behavior: 'smooth', block: 'center' });
        } else {
            console.log("Form validated. Submitting...");
        }
    });
}); 