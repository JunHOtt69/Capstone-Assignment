document.addEventListener("DOMContentLoaded", async function() {
    const quill = new Quill('#commentEditor', {
        theme: 'bubble',
        modules: {
            toolbar: ['bold', 'italic', 'underline', 'link', 'image', { 'list': 'ordered'}, { 'list': 'bullet' }]
        },
        placeholder: 'Type your message here...',
        formats: [
            'bold', 'italic', 'underline', 
            'list', 
            'link', 'image'
        ]
    });

    const sendBtn = document.querySelector('.sendIcon');
    const messageWrapper = document.querySelector('.messageWrapper');
    
    sendBtn.addEventListener('click', function() {
        let content = quill.root.innerHTML;
        const plainText = quill.getText().trim();
        const hasFiles = document.querySelectorAll('.fileCard').length > 0;
        
        if(plainText.length === 0){
            content = "";
        }

        if (plainText.length === 0 && !hasFiles) return;

        
        const formData = new FormData();
        formData.append('content', content);
        formData.append('csrfmiddlewaretoken', CSRF_TOKEN); 

        masterFileList.forEach((file) => {
            formData.append('attachments', file);
        });
        
        fetch(POST_REPLY_URL, { 
            method: 'POST',
            body: formData,
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
            }
        })
        .then(response => {
            if (!response.ok) {
                return response.text().then(text => { throw new Error(text) });
            }
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                const lastComment = messageWrapper.lastElementChild;
                const isSelf = true;
                if (lastComment && lastComment.classList.contains('self')) {
                    const lastBubble = lastComment.querySelector('.bubble:last-child');
                    const lastTimeStr = lastBubble.getAttribute('data-timestamp'); 
                    const lastTime = new Date(lastTimeStr);
                    const currentTime = new Date();

                    const diffMs = currentTime - lastTime;
                    const diffMins = Math.floor(diffMs / 60000);
                    
                    if (diffMins < 10) {
                        const commentContent = lastComment.querySelector('.commentContent');
                        commentContent.insertAdjacentHTML('beforeend', data.bubble_html);
                        finalizeMessageSend();
                        return;
                    }
                }

                messageWrapper.insertAdjacentHTML('beforeend', data.cluster_html);
                finalizeMessageSend();
            }
        })
        .catch(error => console.error('Error:', error));
    });

    function finalizeMessageSend() {
        quill.setContents([]);
        const attComList = document.querySelector('.attComList'); 
        if (attComList) attComList.innerHTML = '';
        masterFileList = [];
        
        const fileInput = document.querySelector('#attachmentsField'); 
        if (fileInput) {
            fileInput.value = ''; 
        }

        const commentContainer = document.querySelector('.commentContainer');
        commentContainer.scrollTo({
            top: commentContainer.scrollHeight,
            behavior: 'smooth'
        });
    }

    const commentContainer = document.querySelector('.commentContainer');
    commentContainer.scrollTo({
        top: commentContainer.scrollHeight,
        behavior: 'smooth'
    });

    const attachmentIcon = document.querySelector('.attachmentIcon');
    const fileInput = document.getElementById('attachmentsField');
    const fileCardList = document.querySelector('.attComList');
    const chatContainer = document.querySelector('.chatContainer');
    const fileError = document.querySelector('.errorMessage');
    let masterFileList = [];
    fileCardList.innerHTML = '';

    ['dragenter', 'dragover', 'dragleave', 'drop'].forEach(eventName => {
        chatContainer.addEventListener(eventName, (e) => {
            e.preventDefault();
            e.stopPropagation();
        }, false);
    });

    ['dragenter', 'dragover'].forEach(eventName => {
        chatContainer.addEventListener(eventName, () => {
            chatContainer.classList.toggle('drag-active', true);
        }, false);
    });

    ['dragleave', 'drop'].forEach(eventName => {
        chatContainer.addEventListener(eventName, () => {
            chatContainer.classList.remove('drag-active');
        }, false);
    });

    attachmentIcon.addEventListener('click', () => fileInput.click());

    chatContainer.addEventListener('drop', (e) => {
        handleFileSelection(Array.from(e.dataTransfer.files));
    });

    fileInput.addEventListener('change', function() {
        handleFileSelection(Array.from(this.files || []));
    });

    function handleFileSelection(newFiles) {
        if (newFiles.length === 0) return;

        const allowedExtensions = ['PDF', 'DOCX', 'XLSX', 'PNG', 'JPG', 'JPEG', 'MP4', 'MOV', 'RAR'];
        const invalidExtensions = [];
        const validNewFiles = [];

        newFiles.forEach(file => {
            const ext = file.name.split('.').pop().toUpperCase();
            if (allowedExtensions.includes(ext)) {
                validNewFiles.push(file);
            } else {
                invalidExtensions.push(file.name);
            }
        });

        if (invalidExtensions.length > 0) {
            showError(`Unsupported file: ${invalidExtensions.join(', ')}`);
            syncInput();
            return;
        }

        if (masterFileList.length + validNewFiles.length > 5) {
            showError("Maximum 5 files allowed.");
            syncInput();
            return;
        }

        masterFileList = [...masterFileList, ...validNewFiles];
        syncInput();
        renderFileCards();
    }

    function syncInput() {
        const dt = new DataTransfer();
        masterFileList.forEach(f => dt.items.add(f));
        fileInput.files = dt.files;
    }

    function showError(msg) {
        fileError.textContent = msg;
        fileError.style.display = 'block';
        setTimeout(() => { fileError.style.display = 'none'; }, 3000);
    }

    function renderFileCards() {
        fileCardList.innerHTML = '';
        
        masterFileList.forEach((file, index) => {
            let extension = file.name.split('.').pop().toUpperCase();
            if (extension === 'JPEG') extension = 'JPG';
            const fileSize = (file.size / 1024).toFixed(1) + ' KB';

            const card = document.createElement('div');
            card.className = 'fileCard';
            card.innerHTML = `
                <span class="fileIcon">
                    <img src="/media/file_icons/${extension}.svg" onerror="this.src='/media/file_icons/FILE.svg'">
                </span>
                <div class="fileDetailWrapper">
                    <p class="fileName">${file.name}</p>
                    <p class="fileSize">${fileSize}</p>
                </div>
                <div class="deleteFile" data-index="${index}">&times;</div>
            `;
            fileCardList.appendChild(card);
        });
    }

    fileCardList.addEventListener('click', (e) => {
        const btn = e.target.closest('.deleteFile');
        if (!btn) return;
        
        const index = parseInt(btn.dataset.index);
        masterFileList.splice(index, 1);
        syncInput();
        renderFileCards();
    });
});

