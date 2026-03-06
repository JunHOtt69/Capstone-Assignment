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


    const extraConfig = document.querySelector('.extraConfig ul');
    const commentIcon = extraConfig.querySelector('.commentIcon');
    const visibleIcon = extraConfig.querySelector('.visibleIcon');
    const attachmentIcon = extraConfig.querySelector('.attachmentIcon');
    const configContent = document.querySelector('.configContent');

    const template = document.getElementById('commentSection').content.cloneNode(true);
    const commentContainer = template.querySelector('.commentContainer');
    configContent.appendChild(commentContainer);

    commentIcon.onclick = () => {
        extraConfig.dataset.config = 'comments';
        const template = document.getElementById('commentSection').content.cloneNode(true);

        if(template){
            const commentContainer = template.querySelector('.commentContainer');
            configContent.innerHTML = ``;
            configContent.appendChild(commentContainer);
        }
    }

    visibleIcon.onclick = () => {
        extraConfig.dataset.config = 'visibility';
        const template = document.getElementById('visiblitySection').content.cloneNode(true);

        if(template){
            configContent.innerHTML = ``;
            configContent.appendChild(template);
        }
    }

    attachmentIcon.onclick = () => {
        extraConfig.dataset.config = 'attachments';
        const template = document.getElementById('attachmentSection').content.cloneNode(true);

        if(template){
            configContent.innerHTML = ``;
            configContent.appendChild(template);
        }
    }

    let idCounter = 1;

    function renderComment(){
        const comments = document.querySelectorAll('.comment');
        comments.forEach(comment => {
            const showReplies = comment.querySelector('.showReplies');
            const repliesContainer = comment.querySelector('.repliesContainer');
            const replyBtn = comment.querySelector('.reply');

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

            const replyEditors = {};

            replyBtn.addEventListener('click', () => {
                renderReply(comment, replyEditors);
            });
        })
    }

    function renderReply(el, dic){
        const template = document.getElementById('commentInput').content.cloneNode(true);
        const editor = template.querySelector('.commentEditor');
        const replyContainer = el.querySelector('.replyContainer');
        
        replyContainer.classList.toggle('active', true);
        replyContainer.innerHTML = ``;
        
        const replyBtnWrapper = document.createElement('div');
        replyBtnWrapper.className = 'replyBtnWrapper';
        
        const cancelBtn = document.createElement('button');
        cancelBtn.className = 'cancel';
        cancelBtn.innerText = 'Cancel';

        cancelBtn.addEventListener('click', () => {
            replyContainer.innerHTML = '';
            replyContainer.classList.toggle('active', false);
        });

        const replyBtn = document.createElement('button');
        replyBtn.className = 'reply';
        replyBtn.innerText = 'Reply';

        idCounter += 1;
        const editorId = `editor${idCounter}`
        editor.id = editorId
        replyContainer.appendChild(editor);
        replyBtnWrapper.appendChild(cancelBtn);
        replyBtnWrapper.appendChild(replyBtn);
        replyContainer.appendChild(replyBtnWrapper);

        dic[editorId] = new Quill(`#${editorId}`, {
            placeholder: 'Compose an epic...',
            theme: 'bubble',
        });

        dic[editorId].focus();
    }
}); 

