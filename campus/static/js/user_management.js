const addBtn = document.getElementById('add-row-btn');
const form = document.querySelector('form');
let lecRow = 0;
let stuRow = 0;

window.addEventListener('beforeunload', (event) => {
    const inputs = document.querySelectorAll('#form-body input');
    let hasData = false;

    inputs.forEach(input => {
        if (input.value.trim() !== '') {
            hasData = true;
        }
    });

    if (hasData) {
        event.preventDefault();
        event.returnValue = ''; 
    }
});

document.addEventListener('DOMContentLoaded', async function() {
    lecRow = 0;
    stuRow = 0;

    const user_role = this.getElementById('id_user_role');
    const admin_button = this.getElementById('admin_role');
    const lecturer_button = this.getElementById('lecturer_role');
    const student_button = this.getElementById('student_role');
    const groupData = JSON.parse(this.getElementById('groups-data').textContent);
    
    admin_button.onclick = function() {
        user_role.value = groupData['admin'];
        renderTable(groupData['admin']);
    }
    
    lecturer_button.onclick = function() {
        user_role.value = groupData['lecturer'];
        renderTable(groupData['lecturer']);
    }

    student_button.onclick = function() {
        user_role.value = groupData['student'];
        renderTable(groupData['student']);
    }

    user_role.value = groupData['admin'];
    renderTable(user_role.value);
});

document.addEventListener('click', (event) => {
    const allSelect = this.querySelectorAll('.selectInput');
    const allCalendar = this.querySelectorAll('.simple-calendar');
    
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

form.addEventListener('submit', (event) => {
    event.preventDefault(); 
    console.log();
});

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

    const djangoHiddenInput = termCell.querySelector('input[type="hidden"]');
    if (djangoHiddenInput) {
        djangoHiddenInput.name = "department_" + i; 
        djangoHiddenInput.id = "id_department_" + i;
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
    
    const deptData = JSON.parse(document.getElementById('dept-data').textContent);
    const termData = JSON.parse(document.getElementById('term-data').textContent);
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);

    if(role == groupData['admin']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="actionField">Action</th>
        `;
        
        lecRow = 0;
        stuRow = 0;
        const form = renderAdminForm();
        body.appendChild(form);
    }

    if(role == groupData['lecturer']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="departmentField">Department</th>
            <th class="actionField">Action</th>
        `;

        lecRow = 1;
        stuRow = 0;
        const form = renderLecturerForm(lecRow, deptData);
        body.appendChild(form);
    }

    if(role == groupData['lecturer']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="intakeField">Intake</th>
            <th class="actionField">Action</th>
        `;
        
        lecRow = 0;
        stuRow = 1;
        const form = renderStudentForm(stuRow, termData);
        body.appendChild(form);
    }
}
