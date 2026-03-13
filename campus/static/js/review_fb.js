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
        if(sendBtn.classList.contains('loading')) return;

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
                const lastComment = messageWrapper.lastElementChild;
                const isSelf = true; // Since the AJAX sender is always 'self'
                
                // Check if a cluster exists and if it's a 'self' cluster
                if (lastComment && lastComment.classList.contains('self')) {
                    const lastBubble = lastComment.querySelector('.bubble:last-child');
                    const lastTimeStr = lastBubble.getAttribute('data-timestamp'); // We'll add this attribute
                    const lastTime = new Date(lastTimeStr);
                    const currentTime = new Date();

                    // Calculate difference in minutes
                    const diffMs = currentTime - lastTime;
                    const diffMins = Math.floor(diffMs / 60000);

                    if (diffMins < 10) {
                        // MATCH! Just append the bubble inside the existing cluster
                        const commentContent = lastComment.querySelector('.commentContent');
                        commentContent.insertAdjacentHTML('beforeend', data.bubble_html);
                        finalizeMessageSend();
                        return;
                    }
                }

                // NO MATCH: Append the whole cluster (icon + bubble)
                messageWrapper.insertAdjacentHTML('beforeend', data.cluster_html);
                finalizeMessageSend();
            }
        })
        .catch(error => console.error('Error:', error));
    });

    function finalizeMessageSend() {
        quill.setContents([]);
        const chatContainer = document.querySelector('.chatContainer');
        chatContainer.scrollTo({ top: chatContainer.scrollHeight, behavior: 'smooth' });
    }
});

