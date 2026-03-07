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
    const configContent = document.querySelector('.configContent');

    const template = document.getElementById('commentSection').content.cloneNode(true);
    configContent.innerHTML = ``;
    configContent.appendChild(template);

    if(commentIcon){
        commentIcon.onclick = () => {
            extraConfig.dataset.config = 'comments';
            const template = document.getElementById('commentSection').content.cloneNode(true);

            if(template){
                configContent.innerHTML = ``;
                renderComment(template);
                configContent.appendChild(template);
            }
        }
    }

    if(visibleIcon){
        visibleIcon.onclick = () => {
            extraConfig.dataset.config = 'visibility';
            const template = document.getElementById('visiblitySection').content.cloneNode(true);
            const container = template.querySelector('.visiblitySection');
            const buttons = template.querySelectorAll('button');

            buttons.forEach(btn => {
                btn.onclick = (e) => {
                    e.preventDefault();
                    container.dataset.controls = btn.innerText.toLowerCase();
                }
            });

            const publicToggle = template.querySelector('#public');
            const adminToggle = template.querySelector('#adminToggle');
            const lecturerToggle = template.querySelector('#lecturerToggle');
            const studentToggle = template.querySelector('#studentToggle');

            
            const roles = {
                'ad' : ['is_ad_visible', '#adminToggle'],
                'lc' : ['is_lc_visible', '#lecturerToggle'],
                'tp' : ['is_tp_visible','#studentToggle'],
            }
            
            let allChecked = true;

            Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
                const djangoInput = document.querySelector(`#id_${djangoId}`);
                console.log(djangoInput.checked);
                const toggle = template.querySelector(toggleId);
                if (djangoInput && toggle){
                    toggle.dataset.value = djangoInput.checked;
                    if(!djangoInput.checked) allChecked = false;
                }
            });

            publicToggle.dataset.value = allChecked;

            function passBooleanValue(newChanges={}){
                const currentState = {
                    'ad': newChanges.hasOwnProperty('ad') ? newChanges['ad'] : (document.getElementById('adminToggle').dataset.value === 'true'),
                    'lc': newChanges.hasOwnProperty('lc') ? newChanges['lc'] : (document.getElementById('lecturerToggle').dataset.value === 'true'),
                    'tp': newChanges.hasOwnProperty('tp') ? newChanges['tp'] : (document.getElementById('studentToggle').dataset.value === 'true'),
                };

                Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
                    if(newChanges.hasOwnProperty(key)){
                        const input = document.querySelector(`#id_${djangoId}`);
                        console.log(input);
                        if (input) input.checked = newChanges[key];
                        
                        const toggle = document.querySelector(toggleId);
                        if(toggle) toggle.dataset.value = newChanges[key];
                        console.log(toggle);
                    }
                });

                const allChecked = Object.values(currentState).every(val => val === true);
                publicToggle.dataset.value = allChecked;
            }

            publicToggle.onclick = (e) => {
                e.preventDefault();
                const isNowTrue = publicToggle.dataset.value !== 'true';
                publicToggle.dataset.value = isNowTrue;
                const fields = {
                    'ad': isNowTrue,
                    'lc': isNowTrue,
                    'tp': isNowTrue,
                };

                passBooleanValue(fields);
            }
            
            adminToggle.onclick = (e) => {
                e.preventDefault();
                const isNowTrue = adminToggle.dataset.value !== 'true';
                console.log('toggled admin', isNowTrue);
                const fields = {
                    'ad': isNowTrue,
                };
                passBooleanValue(fields);
            }

            lecturerToggle.onclick = (e) => {
                e.preventDefault();
                const isNowTrue = lecturerToggle.dataset.value !== 'true';
                console.log('lecturerToggle', isNowTrue);
                const fields = {
                    'lc': isNowTrue,
                };

                passBooleanValue(fields);
            }
            
            studentToggle.onclick = (e) => {
                e.preventDefault();
                const isNowTrue = studentToggle.dataset.value !== 'true';
                console.log('studentToggle', isNowTrue);
                const fields = {
                    'tp': isNowTrue,
                };

                passBooleanValue(fields);
            }

            configContent.innerHTML = ``;
            configContent.appendChild(template);
        }
    }

    let idCounter = 1;

    function renderComment(template){
        const comments = template.querySelectorAll('.comment');
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

