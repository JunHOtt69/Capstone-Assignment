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
        placeholder: ' ',
        formats: [
            'size', 
            'bold', 'italic', 'underline', 
            'list', 
            'link', 'image'
        ]
    });

    const hiddenContent = document.querySelector('#id_content').value;
    if (hiddenContent && hiddenContent.trim() !== "") {
        quill.root.innerHTML = hiddenContent;
    }else {
        quill.setContents([]); 
    }

    const contentInput = document.querySelector('#id_content');
    quill.on('text-change', function() {
        const html = quill.root.innerHTML;
        contentInput.value = html;
    });


    const faqForm = document.getElementById('faq');
    const saveBtn = document.querySelector('.save');
    const discardBtn = document.querySelector('.cancel');

    discardBtn.addEventListener('click', (e) => {
        e.preventDefault(); 
        
        const confirmDiscard = confirm("Are you sure you want to discard your changes? All unsaved progress will be lost.");
        
        if (confirmDiscard) {
            window.location.reload();
        }
    });

    saveBtn.addEventListener('click', (e) => {
        contentInput.value = quill.root.innerHTML;
        const category =  document.querySelector('#id_category').value;
        
        isSubmitting = true;

        if (quill.getText().trim().length === 0) {
            e.preventDefault();
            isSubmitting = false;
            alert("The FAQ content cannot be empty!");
        } 
        else if(category == ''){
            e.preventDefault();
            isSubmitting = false;
            alert("The FAQ category cannot be empty!");
        }
    });

    const categoryInput = document.getElementById('id_category');
    const selectInput = document.getElementById('categorySelect');
    const selectedLabel = selectInput.querySelector('.selectedLabel');
    const categoryOptions = document.getElementById('categoryOptions');

    selectedLabel.addEventListener('click', () => {
        const isNowTrue = selectInput.classList.contains('active');
        selectInput.classList.toggle('active', !isNowTrue);
    });

    categoryOptions.addEventListener('change', (event) => {
        if(event.target.type === 'radio'){
            const chosenText = event.target.nextElementSibling.innerText;
            const selectInput = event.target.closest('.selectInput');
            const displayLabel = selectInput.querySelector('.selectedLabel label');

            displayLabel.innerText = `Category: ${chosenText}`;
            selectInput.classList.toggle('active', false);
            
            categoryInput.value = event.target.value;
        }
    });


    const extraConfig = document.querySelector('.extraConfig ul');
    const commentIcon = extraConfig.querySelector('.commentIcon');
    const visibleIcon = extraConfig.querySelector('.visibleIcon');
    const configContent = document.querySelector('.configContent');

    const roles = {
        'ad' : ['is_ad_visible', '#adminToggle'],
        'lc' : ['is_lc_visible', '#lecturerToggle'],
        'tp' : ['is_tp_visible','#studentToggle'],
        'vr' : ['is_visitor_visible','#visitorToggle'],
    }

    renderVisibility();
    let allChecked = true;

    Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
        const djangoInput = document.querySelector(`#id_${djangoId}`);
        const toggle = document.querySelector(toggleId);
        if (djangoInput && toggle){
            const val = djangoInput.value === 'True';
            toggle.dataset.value = val;

            if(!val) allChecked = false;
        }
    });

    document.querySelector('#public').dataset.value = allChecked;
    const icon = document.querySelector('#visiblity');
    icon.dataset.visible = allChecked;


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
            renderVisibility();
        }
    }

    let idCounter = 1;

    function renderVisibility(){
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
        const visitorToggle = template.querySelector('#visitorToggle');

        let allChecked = true;

        Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
            const djangoInput = document.querySelector(`#id_${djangoId}`);
            const toggle = template.querySelector(toggleId);
            if (djangoInput && toggle){
                const val = djangoInput.value === 'True';
                toggle.dataset.value = val;
                
                if(!val) allChecked = false;
            }
        });

        publicToggle.dataset.value = allChecked;

        function passBooleanValue(newChanges={}){
            const currentState = {
                'ad': newChanges.hasOwnProperty('ad') ? newChanges['ad'] : (document.getElementById('adminToggle').dataset.value === 'true'),
                'lc': newChanges.hasOwnProperty('lc') ? newChanges['lc'] : (document.getElementById('lecturerToggle').dataset.value === 'true'),
                'tp': newChanges.hasOwnProperty('tp') ? newChanges['tp'] : (document.getElementById('studentToggle').dataset.value === 'true'),
                'vr': newChanges.hasOwnProperty('vr') ? newChanges['vr'] : (document.getElementById('visitorToggle').dataset.value === 'true'),
            };

            Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
                if(newChanges.hasOwnProperty(key)){
                    const input = document.querySelector(`#id_${djangoId}`);
                    if (input) input.value = newChanges[key] ? 'True' : 'False';
                    
                    const toggle = document.querySelector(toggleId);
                    if(toggle) toggle.dataset.value = newChanges[key];
                }
            });

            const allChecked = Object.values(currentState).every(val => val === true);
            publicToggle.dataset.value = allChecked;

            const icon = document.querySelector('#visiblity');
            icon.dataset.visible = allChecked;
        }

        publicToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = publicToggle.dataset.value !== 'true';
            publicToggle.dataset.value = isNowTrue;
            const fields = {
                'ad': isNowTrue,
                'lc': isNowTrue,
                'tp': isNowTrue,
                'vr': isNowTrue,
            };

            passBooleanValue(fields);
        }
        
        adminToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = adminToggle.dataset.value !== 'true';
            const fields = {
                'ad': isNowTrue,
            };
            passBooleanValue(fields);
        }

        lecturerToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = lecturerToggle.dataset.value !== 'true';
            const fields = {
                'lc': isNowTrue,
            };

            passBooleanValue(fields);
        }
        
        studentToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = studentToggle.dataset.value !== 'true';
            const fields = {
                'tp': isNowTrue,
            };

            passBooleanValue(fields);
        }

        visitorToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = visitorToggle.dataset.value !== 'true';
            const fields = {
                'ad': isNowTrue,
                'lc': isNowTrue,
                'tp': isNowTrue,
                'vr': isNowTrue,
            };

            passBooleanValue(fields);
        }

        configContent.innerHTML = ``;
        configContent.appendChild(template);
    }

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
            placeholder: 'Say Someting...',
            theme: 'bubble',
        });

        dic[editorId].focus();
    }

    function captureInitialState() {
        initialData = {
            title: document.querySelector('#id_title').value,
            content: document.querySelector('#id_content').value,
            category: document.querySelector('#id_category').value,
            ad: document.querySelector('#id_is_ad_visible').value,
            lc: document.querySelector('#id_is_lc_visible').value,
            tp: document.querySelector('#id_is_tp_visible').value,
            vr: document.querySelector('#id_is_visitor_visible').value
        };
    }

    captureInitialState();
}); 

document.addEventListener('click', (e) => {
    const selectInput = document.getElementById('categorySelect');
    const categoryOptions = document.getElementById('categoryOptions');
    
    if(!selectInput.contains(e.target) && !categoryOptions.contains(e.target)){
        selectInput.classList.toggle('active', false);
    }
});

window.addEventListener('beforeunload', (event) => {
    if (isSubmitting) return;

    const currentData = {
        title: document.querySelector('#id_title').value,
        content: document.querySelector('#id_content').value,
        category: document.querySelector('#id_category').value,
        ad: document.querySelector('#id_is_ad_visible').value,
        lc: document.querySelector('#id_is_lc_visible').value,
        tp: document.querySelector('#id_is_tp_visible').value,
        vr: document.querySelector('#id_is_visitor_visible').value
    };

    console.log()

    const hasChanged = 
        currentData.title !== initialData.title ||
        currentData.content !== initialData.content ||
        currentData.category !== initialData.category ||
        currentData.ad !== initialData.ad ||
        currentData.lc !== initialData.lc ||
        currentData.vr !== initialData.vr ||
        currentData.tp !== initialData.tp;

    if (hasChanged) {
        event.preventDefault();
        event.returnValue = ''; 
    }
});
