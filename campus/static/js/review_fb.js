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

});