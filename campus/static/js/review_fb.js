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
        const content = quill.root.innerHTML;
        
        if (quill.getText().trim().length === 0) return;

        const formData = new FormData();
        formData.append('content', content);
        formData.append('csrfmiddlewaretoken', CSRF_TOKEN); 

        fetch(FEEDBACK_URL, { 
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
                messageWrapper.insertAdjacentHTML('beforeend', data.html);
                quill.setContents([]);
                
                const chatContainer = document.querySelector('.chatContainer');
                chatContainer.scrollTo({
                    top: chatContainer.scrollHeight,
                    behavior: 'smooth'
                });
            }
        })
        .catch(error => console.error('Error:', error));
    });

});