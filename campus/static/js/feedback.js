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

    categorySelect.addEventListener('click', (e) => {
        categorySelect.classList.toggle('active');
        e.stopPropagation();
    });

    document.addEventListener('click', () => {
        categorySelect.classList.remove('active');
    });

    options.forEach(opt => {
        opt.addEventListener('change', () => {
            const labelText = opt.nextElementSibling.innerText;
            selectedLabel.innerText = labelText;
            
            if(realCategoryInput) realCategoryInput.value = opt.value;
            
            categorySelect.classList.remove('active');
            
            const query = document.querySelector('#id_title').value.trim();
            fetchSuggestions(query);
        });
    });

    const titleInput = document.querySelector('#id_title');
    const suggestionsList = document.getElementById('faqSuggestions');

    let suggestionRequestId = 0;

    const fetchSuggestions = async (query) => {
        const requestId = ++suggestionRequestId;
        
        const selectedCategory = document.querySelector('input[name="category"]:checked')?.value || "";

        try {
            const response = await fetch(`/suggestions/?q=${encodeURIComponent(query)}&cat=${encodeURIComponent(selectedCategory)}`);
            const data = await response.json();
            console.log(data);
            if (requestId !== suggestionRequestId) return;

            renderSuggestions(data.suggestions || []);
        } catch (error) {
            console.error("Fetch error:", error);
            suggestionsList.innerHTML = '';
            suggestionsList.classList.remove('visible');
        }
    };

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

    uploadBox.addEventListener('click', () => fileInput.click());

    fileInput.addEventListener('change', function() {
        const files = Array.from(this.files);
        
        if (files.length > 0) {
            fileCardList.innerHTML = ''; 
            fileCardList.classList.remove('hide');
            uploadPrompt.classList.add('hide');

            files.forEach((file, index) => {
                const extension = file.name.split('.').pop().toUpperCase();
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
                    <div class="deleteFile" data-index="${index}">
                        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
                        </svg>
                    </div>
                `;
                fileCardList.appendChild(card);
            });
        } else {
            fileCardList.classList.add('hide');
            uploadPrompt.classList.remove('hide');
        }
    });
}); 