document.addEventListener("DOMContentLoaded", function() {
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
        placeholder: ' ',
        formats: [
            'size', 
            'bold', 'italic', 'underline', 
            'list', 
            'link', 'image'
        ]
    });

    const contentInput = document.querySelector('#id_content');

    quill.on('text-change', function() {
        const html = quill.root.innerHTML;
        contentInput.value = html;
    });
});

