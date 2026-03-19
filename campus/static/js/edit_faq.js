let isSubmitting = false;
let initialData = {};
const fieldSelectors = {
    title: '#id_title',
    subject: '#id_subject',
    content: '#id_content',
    category: '#id_category',
    type: '#id_announcement_type',
    is_active: '#id_is_active',
    tp: '#id_is_tp_visible',
    lc: '#id_is_lc_visible',
    ad: '#id_is_ad_visible',
    vr: "#id_is_visitor_visible",
    intake: '#id_academic_term',
};

document.addEventListener("DOMContentLoaded", async function() {
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
    const deleteBtn = document.querySelector('.delete');

    if(discardBtn){
        discardBtn.addEventListener('click', (e) => {
            e.preventDefault(); 
            
            const confirmDiscard = confirm("Are you sure you want to discard your changes? All unsaved progress will be lost.");
            
            if (confirmDiscard) {
                window.location.reload();
            }
        });
    }
    

    if(saveBtn){
        saveBtn.addEventListener('click', (e) => {
            contentInput.value = quill.root.innerHTML;
            const category =  document.querySelector('#id_category');
            const type = document.querySelector('#id_announcement_type');
            isSubmitting = true;

            if (quill.getText().trim().length === 0) {
                e.preventDefault();
                isSubmitting = false;

                if(category) alert("The FAQ content cannot be empty!");
                if(type) alert("The announcement content cannot be empty!");
            } 

            if(category && category.value == ''){
                e.preventDefault();
                isSubmitting = false;
                alert("The FAQ category cannot be empty!");
            }
            
            if(type && type.value == ''){
                e.preventDefault();
                isSubmitting = false;
                alert("The announcement type cannot be empty!");
            }
        });
    }

    if(deleteBtn){
        deleteBtn.onclick = (e) => {
            e.preventDefault();
            if (confirm("Are you sure you want to delete this FAQ? This cannot be undone.")) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = `/delete-faq/${deleteBtn.dataset.slug}/`;

                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = 'csrfmiddlewaretoken';
                csrfInput.value = document.querySelector('[name=csrfmiddlewaretoken]').value;
                
                form.appendChild(csrfInput);
                document.body.appendChild(form);
                
                form.submit();
            }
        }
    }


    const categoryInput = document.getElementById('id_category');
    const announcement_typeInput = document.getElementById('id_announcement_type');
    const selectInput = document.getElementById('categorySelect');
    const selectedLabel = selectInput.querySelector('.selectedLabel');
    const categoryOptions = document.getElementById('categoryOptions');
    const typeOptions = document.getElementById('typeOptions');

    if(selectedLabel){
        selectedLabel.addEventListener('click', () => {
            const isNowTrue = selectInput.classList.contains('active');
            selectInput.classList.toggle('active', !isNowTrue);
        });
    }
    if(categoryOptions){
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
    }
    
    if(typeOptions){
        typeOptions.addEventListener('change', (event) => {
            if(event.target.type === 'radio'){
                const chosenText = event.target.nextElementSibling.innerText;
                const selectInput = event.target.closest('.selectInput');
                const displayLabel = selectInput.querySelector('.selectedLabel label');

                displayLabel.innerText = `Type: ${chosenText}`;
                selectInput.classList.toggle('active', false);
                
                
                announcement_typeInput.value = event.target.value;
                console.log(announcement_typeInput.value);
            }
        });
    }

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
            if(btn){
                btn.onclick = (e) => {
                    e.preventDefault();
                    container.dataset.controls = btn.innerText.toLowerCase();
                }
            }
            
        });

        const publicToggle = template.querySelector('#public');
        const adminToggle = template.querySelector('#adminToggle');
        const lecturerToggle = template.querySelector('#lecturerToggle');
        const studentToggle = template.querySelector('#studentToggle');
        const visitorToggle = template.querySelector('#visitorToggle');
        const termViewInput = template.querySelector('#intakeSelect');
        const intakeOptions = template.querySelector('#intakeOptions');
        const academic_term_input = document.querySelector('#id_academic_term');
        const selectedContainer = template.querySelector('#selectedIntakesContainer');
        let selectedIds = []
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
        
        if(publicToggle){
            publicToggle.dataset.value = allChecked;
        }

        function passBooleanValue(newChanges={}){
            const currentState = {};
            Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
                const toggle = document.querySelector(toggleId);
                if (toggle) {
                    const isChecked = newChanges.hasOwnProperty(key) 
                        ? newChanges[key] 
                        : (toggle.dataset.value === 'true' || toggle.dataset.value === true);
                    currentState[key] = isChecked;
                }
            });

            Object.entries(roles).forEach(([key, [djangoId, toggleId]]) => {
                if(newChanges.hasOwnProperty(key)){
                    const input = document.querySelector(`#id_${djangoId}`);
                    if (input) input.value = newChanges[key] ? 'True' : 'False';
                    
                    const toggle = document.querySelector(toggleId);
                    if(toggle) toggle.dataset.value = newChanges[key];
                }
            });

            const allChecked = Object.values(currentState).every(val => val === true);
            if(publicToggle) publicToggle.dataset.value = allChecked;

            const icon = document.querySelector('#visiblity');
            icon.dataset.visible = allChecked;
        }

        if(publicToggle){
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
        }}
        
        if(adminToggle){
            adminToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = adminToggle.dataset.value !== 'true';
            const fields = {
                'ad': isNowTrue,
            };
            passBooleanValue(fields);
        }}

        if(lecturerToggle){
            lecturerToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = lecturerToggle.dataset.value !== 'true';
            const fields = {
                'lc': isNowTrue,
            };

            passBooleanValue(fields);
        }}
        
        if(studentToggle){
            studentToggle.onclick = (e) => {
            e.preventDefault();
            const isNowTrue = studentToggle.dataset.value !== 'true';

            if (isNowTrue) {
                selectedIds = [];
                updateHiddenInput();
            
                if (selectedContainer) {
                    selectedContainer.innerHTML = '';
                }
                
                if (intakeOptions) {
                    const options = intakeOptions.querySelectorAll('.option');
                    options.forEach(option => {
                        option.style.display = 'block';
                    });
                }

                const intakeWrapper = template.querySelector('#intakeWrapper');
                if (intakeWrapper) {
                    intakeWrapper.style.display = 'none';
                }
            } else {
                const intakeWrapper = template.querySelector('#intakeWrapper');
                if (intakeWrapper) {
                    intakeWrapper.style.display = 'flex';
                }
            }

            const fields = {
                'tp': isNowTrue,
            };

            passBooleanValue(fields);
        }}

        if(visitorToggle){
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
        }}

        if(termViewInput){
            termViewInput.addEventListener('click', () => {
                const remainingOptions = Array.from(intakeOptions.querySelectorAll('.option'))
                    .filter(opt => opt.style.display !== 'none');

                if (remainingOptions.length === 0) {
                    return;
                }

                termViewInput.classList.toggle('active', true);
            });
        }
        
        if(intakeOptions){
            intakeOptions.addEventListener('click', (e) => {
                e.stopPropagation();

                const option = e.target.closest('.option');
                if (!option) return;

                const id = option.dataset.id;
                const code = option.dataset.code;

                selectedIds.push(id);
                updateHiddenInput();

                const tag = document.createElement('div');
                tag.className = 'intake-tag';
                tag.dataset.id = id;
                tag.innerHTML = `
                    <span>${code}</span>
                    <span class="remove-tag" onclick="removeIntake('${id}', '${code}')">&times;</span>
                `;
                selectedContainer.appendChild(tag);

                option.style.display = 'none';

                const remainingOptions = Array.from(intakeOptions.querySelectorAll('.option'))
                    .filter(opt => opt.style.display !== 'none');

                if (remainingOptions.length === 0) {
                    termViewInput.classList.remove('active');
                }
            });

            document.addEventListener('click', (e) => {
                if(!termViewInput.contains(e.target) && !intakeOptions.contains(e.target)){
                    termViewInput.classList.toggle('active', false);
                }
            });
        }

        window.removeIntake = function(id, code) {
            selectedIds = selectedIds.filter(item => item !== id);
            updateHiddenInput();

            const tag = selectedContainer.querySelector(`.intake-tag[data-id="${id}"]`);
            if (tag) tag.remove();

            const option = intakeOptions.querySelector(`.option[data-id="${id}"]`);
            if (option) option.style.display = 'block';
        }

        function updateHiddenInput() {
            academic_term_input.value = selectedIds.join(',');
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
        for(const [key, selector] of Object.entries(fieldSelectors)){
            const element = document.querySelector(selector);
    
            if (element) {
                initialData[key] = element.value;
            }
        }
    }

    captureInitialState();
}); 

document.addEventListener('click', (e) => {
    const selectInput = document.getElementById('categorySelect');
    const options = document.getElementById('categoryOptions') || document.getElementById('typeOptions');
    
    if(!selectInput.contains(e.target) && !options.contains(e.target)){
        selectInput.classList.toggle('active', false);
    }
});

window.addEventListener('beforeunload', (event) => {
    if (isSubmitting) return;

    let currentData = {};
    for(const [key, selector] of Object.entries(fieldSelectors)){
        const element = document.querySelector(selector);
        if (element) {
            currentData[key] = element.value;
        }
    }

    const hasChanged = Object.keys(currentData).some(key => {
        return initialData.hasOwnProperty(key) && currentData[key] !== initialData[key]
    });

    if (hasChanged) {
        event.preventDefault();
        event.returnValue = ''; 
    }
});
