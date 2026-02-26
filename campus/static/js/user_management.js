const addBtn = document.getElementById('add-row-btn');
const form = document.querySelector('form');
let lecRow = 0;
let stuRow = 0;
let isSubmitting = false;

window.addEventListener('beforeunload', (event) => {
    const inputs = document.querySelectorAll('#form-body input');
    let hasData = false;

    inputs.forEach(input => {
        if (input.value.trim() !== '') {
            hasData = true;
        }
    });

    if(isSubmitting) return;
    if (hasData) {
        event.preventDefault();
        event.returnValue = ''; 
    }
});

document.addEventListener('DOMContentLoaded', async function() {
    lecRow = 0;
    stuRow = 0;

    const user_role = document.getElementById('id_user_role');
    const admin_button = document.getElementById('admin_role');
    const lecturer_button = document.getElementById('lecturer_role');
    const student_button = document.getElementById('student_role');
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);
    const roleRaw = JSON.parse(document.getElementById('role-data').textContent);
    const roleIdInt = roleRaw ? parseInt(roleRaw, 10) : null;
    console.log(roleIdInt)
    console.log(roleRaw)
    function attemptSwitchRole(role){
        user_role.value = role;
        renderTable(user_role.value);
    }

    admin_button.onclick = () => attemptSwitchRole(groupData['admin']);
    lecturer_button.onclick = () => attemptSwitchRole(groupData['lecturer']); 
    student_button.onclick = () => attemptSwitchRole(groupData['student']); 

    if(roleIdInt == groupData['lecturer']){
        user_role.value = groupData['lecturer'];
        renderTable(user_role.value);
    }else if(roleIdInt == groupData['student']){
        user_role.value = groupData['student'];
        renderTable(user_role.value);
    }else{
        user_role.value = groupData['admin'];
        renderTable(user_role.value);
    }
    
});

document.addEventListener('click', (event) => {
    const allSelect = document.querySelectorAll('.selectInput');
    const allCalendar = document.querySelectorAll('.simple-calendar');
    
    allSelect.forEach(dropdown => {
        if (!dropdown.contains(event.target)) {
            dropdown.classList.remove('active');
        }
    });
});

addBtn.addEventListener('click', (event) => {
    const tableBody = document.getElementById('form-body');
    
    const num_of_row = document.getElementById('num-of-row');
    const user_role = document.getElementById('id_user_role');

    event.preventDefault();
    const rowCount = Number(num_of_row.value);
    const deptData = JSON.parse(document.getElementById('dept-data').textContent);
    const termData = JSON.parse(document.getElementById('term-data').textContent);
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);

    if (Number.isInteger(rowCount) && rowCount > 0){
        for(let i = 0; i < rowCount; i++){
            
            if(user_role.value == groupData['admin']){
                const form = renderAdminForm();
                tableBody.appendChild(form);
            } 
            else if(user_role.value == groupData['lecturer']){
                lecRow += 1; 
                const form = renderLecturerForm(lecRow, deptData);
                tableBody.appendChild(form);
            }
            else if(user_role.value == groupData['student']){
                stuRow += 1; 
                const form = renderStudentForm(stuRow, termData);
                tableBody.appendChild(form);
            }
        }

        num_of_row.value = '';
    }
    else{
        alert("Number of row need to be at least 1.");
    }
});

form.onsubmit = async function(event) {
    event.preventDefault(); 
    console.log("Form submission intercepted!");
    isSubmitting = true;

    const messageContainer = document.getElementById('errorMessageContainer');
    messageContainer.innerHTML = ``;

    const roleInputs = document.getElementById('id_user_role').value;
    const emailInputs = document.getElementsByName('email');
    const f_nameInputs = document.getElementsByName('first_name')
    const l_nameInputs = document.getElementsByName('last_name')
    const emailList = Array.from(emailInputs).map(input => input.value);
    const f_nameList = Array.from(f_nameInputs).map(input => input.value);
    const l_nameList = Array.from(l_nameInputs).map(input => input.value);
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);

    let errors = [];
    if (emailList.length === 0) return;

    const params = new URLSearchParams();
    emailList.forEach((email, index) => params.append('emails[]', email));
    
    f_nameInputs.forEach((input, index) => {
        const rowNumber = index + 1;
        if (!input.value.trim()) {
            errors.push(`Error in row No.${rowNumber}: first name is empty.`);
        }
    });

    l_nameInputs.forEach((input, index) => {
        const rowNumber = index + 1;
        if (!input.value.trim()) {
            errors.push(`Error in row No.${rowNumber}: last name is empty.`);
        }
    });

    if(roleInputs == groupData['student']){
        const totalRow = f_nameList.length;
        for(let i = 0; i < totalRow; i++){
            const rowNumber = i + 1;
            const checkedRadio = document.querySelector(`input[name="temp_radio_${rowNumber}"]:checked`);
            
            if(!checkedRadio){
                errors.push(`Error in row No.${rowNumber}: Please select an academic term.`);
            }
        }
    }
    
    if(errors.length > 0){
            isSubmitting = false;
            errors.forEach(error => {
                const errorMessage = document.createElement('p');
                errorMessage.innerHTML = error;
                messageContainer.appendChild(errorMessage);
            })
            return;
        }

    try{
        const response = await fetch(`/check-email/?${params.toString()}`);
        const data = await response.json();
        

        if(data.is_taken){
            data.taken_emails.forEach(email => {
                const rowNumber = email.index;
                errors.push(`Error in row No.${rowNumber}: ${email.email} is already registered.`)
            });
        } 

        if(errors.length > 0){
            isSubmitting = false;
            errors.forEach(error => {
                const errorMessage = document.createElement('p');
                errorMessage.innerHTML = error;
                messageContainer.appendChild(errorMessage);
            })
            return;
        }else{
            form.submit();
        }
    } catch(error){
        console.error('validation failed: ', error);
        const errorMessage = document.createElement('p');
        errorMessage.innerHTML = `An error occurred during validation. Please try again.`
        messageContainer.appendChild(errorMessage);
    }
};

function removeRow(btn) {
    const tableBody = document.getElementById('form-body');
    if (tableBody.rows.length > 1) {
        btn.closest('tr').remove();
    } else {
        alert("At least one user is required.");
    }
}

function clearBtn(btn){
    const container = btn.closest('td');
    const input = container.querySelector('input');

    if(input){
        input.value = '';
    }
}

function renderRoleButton(role){
    const user_role_button = document.getElementById('user_role');
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);

    if(role == groupData['admin']){
        user_role_button.classList.remove('lecturer');
        user_role_button.classList.remove('student');
        user_role_button.classList.add('admin');
    }

    if(role == groupData['lecturer']){
        user_role_button.classList.remove('admin');
        user_role_button.classList.remove('student');
        user_role_button.classList.add('lecturer');
    }

    if(role == groupData['student']){
        user_role_button.classList.remove('lecturer');
        user_role_button.classList.remove('admin');
        user_role_button.classList.add('student');
    }
}

function renderAdminForm(){
    let clone;
    const template = document.getElementById('row-template');
    clone = template.content.cloneNode(true);
    const row = clone.querySelector('tr');

    row.classList.add('adminUser');

    const first_name = row.querySelector('#id_first_name');
    const last_name = row.querySelector('#id_last_name');
    const email = row.querySelector('#id_email');

    if(first_name){
        first_name.name = 'first_name';
        first_name.id = '';
    }

    if(last_name){
        last_name.name = 'last_name';
        last_name.id = '';
    }

    if(email){
        email.name = 'email';
        email.id = '';
    }

    return row;
}

function renderLecturerForm(i, data){
    const template = document.getElementById('row-template');
    const clone_template  = template.content.cloneNode(true);
    const row = clone_template.querySelector('tr');
    row.classList.add('lecturerUser');
    const actionCell = row.querySelector('.actionField');

    const _input = document.getElementById('departmentInput').content.cloneNode(true);
    const departmentCell = _input.querySelector('td');

    const djangoHiddenInput = departmentCell.querySelector('input[type="hidden"]');

    const first_name = row.querySelector('#id_first_name');
    const last_name = row.querySelector('#id_last_name');
    const email = row.querySelector('#id_email');

    if(first_name){
        first_name.name = 'first_name';
        first_name.id = '';
    }

    if(last_name){
        last_name.name = 'last_name';
        last_name.id = '';
    }

    if(email){
        email.name = 'email';
        email.id = '';
    }

    if (djangoHiddenInput) {
        djangoHiddenInput.name = "department_" + i; 
        djangoHiddenInput.id = "id_department_" + i;
    }

    const selectInput = departmentCell.querySelector('.selectInput');
    const selectedLabel = departmentCell.querySelector('.selectedLabel');
    const optionContainer = departmentCell.querySelector('.optionContainer');

    optionContainer.innerHTML = data.map(department => `
        <div class="option">
            <input type="radio" name="temp_radio_${i}" id="${department.dept_id}-${i}" value="${department.dept_id}">
            <label for="${department.dept_id}-${i}">${department.dept_name}</label>
        </div>
    `).join('');

    selectedLabel.addEventListener('click', () => {
        selectInput.classList.add('active');
    });

    optionContainer.addEventListener('change', (event) => {
        if(event.target.type === 'radio'){
            const chosenText = event.target.nextElementSibling.innerText;
            departmentCell.querySelector('.selectedLabel label').innerText = chosenText;

            if (djangoHiddenInput) {
                djangoHiddenInput.value = event.target.value;
            }

            selectInput.classList.remove('active');
        }
    });

    row.insertBefore(departmentCell, actionCell);
    return row;
}

function renderStudentForm(i, data){
    const template = document.getElementById('row-template');
    const clone_template  = template.content.cloneNode(true);
    const row = clone_template.querySelector('tr');
    row.classList.add('studentUser');
    const actionCell = row.querySelector('.actionField');

    const _input = document.getElementById('termInput').content.cloneNode(true);
    const termCell = _input.querySelector('td');

    const first_name = row.querySelector('#id_first_name');
    const last_name = row.querySelector('#id_last_name');
    const email = row.querySelector('#id_email');

    if(first_name){
        first_name.name = 'first_name';
        first_name.id = '';
    }

    if(last_name){
        last_name.name = 'last_name';
        last_name.id = '';
    }

    if(email){
        email.name = 'email';
        email.id = '';
    }

    const djangoHiddenInput = termCell.querySelector('input[type="hidden"]');
    if (djangoHiddenInput) {
        djangoHiddenInput.name = "term_" + i; 
        djangoHiddenInput.id = "id_term_" + i;
    }

    const selectInput = termCell.querySelector('.selectInput');
    const selectedLabel = termCell.querySelector('.selectedLabel');
    const optionContainer = termCell.querySelector('.optionContainer');

    optionContainer.innerHTML = data.map(term => `
        <div class="option">
            <input type="radio" name="temp_radio_${i}" id="${term.term_id}-${i}" value="${term.term_id}">
            <label for="${term.term_id}-${i}">${term.intake_code}</label>
        </div>
    `).join('');

    selectedLabel.addEventListener('click', () => {
        selectInput.classList.add('active');
    });

    optionContainer.addEventListener('change', (event) => {
        if(event.target.type === 'radio'){
            const chosenText = event.target.nextElementSibling.innerText;
            termCell.querySelector('.selectedLabel label').innerText = chosenText;

            if (djangoHiddenInput) {
                djangoHiddenInput.value = event.target.value;
            }

            selectInput.classList.remove('active');
        }
    });

    row.insertBefore(termCell, actionCell);
    return row;
}

function renderTable(role){
    const user_table = document.getElementById('user-table');
    const header = document.querySelector('#user-table thead tr');
    const body = document.querySelector('#form-body');
    
    renderRoleButton(role);

    header.innerHTML = '';
    body.innerHTML = '';
    lecRow = 0;
    stuRow = 0;
    
    const deptData = JSON.parse(document.getElementById('dept-data').textContent);
    const termData = JSON.parse(document.getElementById('term-data').textContent);
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);
    const messageContainer = document.getElementById('errorMessageContainer');
    messageContainer.innerHTML = ``;
    
    if(role == groupData['admin']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="actionField">Action</th>
        `;
        
        const form = renderAdminForm();
        body.appendChild(form);
    }

    else if(role == groupData['lecturer']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="departmentField">Department</th>
            <th class="actionField">Action</th>
        `;

        lecRow = 1;
        const form = renderLecturerForm(lecRow, deptData);
        body.appendChild(form);
    }

    else if(role == groupData['student']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="intakeField">Intake</th>
            <th class="actionField">Action</th>
        `;
        
        stuRow = 1;
        const form = renderStudentForm(stuRow, termData);
        body.appendChild(form);
    }
}
