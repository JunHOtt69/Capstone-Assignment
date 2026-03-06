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

    const comments = document.querySelectorAll('.comment');
    comments.forEach(comment => {
        const showReplies = comment.querySelector('.showReplies');
        const repliesContainer = comment.querySelector('.repliesContainer');

        comment.style.setProperty('--last-child', `0vw`);
        comment.style.setProperty('--extra-len', `1.2vw`);

        function addShowBtn(el){
            const showBtn = el.querySelector('.show');
            const content = el.querySelector('.commentContent');

            if(showBtn && content.scrollHeight > content.clientHeight){
                showBtn.classList.add('visible');
                showBtn.addEventListener('click', (e) => {
                    e.stopPropagation();

                    if(content.classList.contains('expanded')){
                        const paragraphs = content.querySelectorAll('p');

                        content.style.display = '-webkit-box'; 
                        content.style.webkitLineClamp = '4';

                        paragraphs.forEach(p => p.style.display = 'inline');
                        content.classList.toggle('expanded', false);
                    }else{
                        // expanding
                        const paragraphs = content.querySelectorAll('p');

                        content.style.display = 'block'; 
                        content.style.webkitLineClamp = 'none';

                        paragraphs.forEach(p => p.style.display = 'block');
                        
                        content.classList.toggle('expanded', true);
                    }
                })
            }
        }
        
        addShowBtn(comment);
        
        if(showReplies){
            showReplies.addEventListener('click', () => {
                const parent = showReplies.closest('.showMoreReplies');
                const replies = repliesContainer.querySelectorAll('.comment');
                if(parent.classList.contains('expanded')){
                    parent.classList.toggle('expanded', false);
                }else{
                    parent.classList.toggle('expanded', true);
                    
                    replies.forEach((reply) => {
                        addShowBtn(reply);
                    });
                }
            });
        }
    })
}); 