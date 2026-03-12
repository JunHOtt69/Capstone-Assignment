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

}); 