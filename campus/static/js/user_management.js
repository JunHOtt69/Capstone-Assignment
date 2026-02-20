const addBtn = document.getElementById('add-row-btn');
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

    const user_role = document.getElementById('id_user_role');
    const user_role_button = document.getElementById('user_role');
    const admin_button = document.getElementById('admin_role');
    const lecturer_button = document.getElementById('lecturer_role');
    const student_button = document.getElementById('student_role');

    admin_button.onclick = function() {
        user_role.value = 1;
        renderTable(1);
        user_role_button.classList.remove('lecturer');
        user_role_button.classList.remove('student');
        user_role_button.classList.add('admin');
    }
    
    lecturer_button.onclick = function() {
        user_role.value = 2;
        renderTable(2);
        user_role_button.classList.remove('admin');
        user_role_button.classList.remove('student');
        user_role_button.classList.add('lecturer');
    }

    student_button.onclick = function() {
        user_role.value = 3;
        renderTable(3);
        user_role_button.classList.remove('lecturer');
        user_role_button.classList.remove('admin');
        user_role_button.classList.add('student');
    }

    user_role_button.classList.remove('lecturer');
    user_role_button.classList.remove('student');
    user_role_button.classList.add('admin');
    user_role.value = 1;

    renderTable(user_role.value);
});

addBtn.addEventListener('click', (event) => {
    const tableBody = document.getElementById('form-body');
    const admin_template = document.getElementById('row-template');
    const num_of_row = document.getElementById('num-of-row');
    const user_role = document.getElementById('id_user_role');

    event.preventDefault();
    const rowCount = Number(num_of_row.value);
    console.log(rowCount);

    if (Number.isInteger(rowCount) && rowCount > 0){
        for(let i = 0; i < rowCount; i++){
            let clone;
            if(user_role.value == 1) clone = admin_template.content.cloneNode(true);
            if(user_role.value == 2) clone = lecturer_template.content.cloneNode(true);
            if(user_role.value == 3) clone = student_template.content.cloneNode(true);
            tableBody.appendChild(clone);
        }

        num_of_row.value = '';
    }
    else{
        alert("Number of row need to be at least 1.");
    }
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

function renderLecturerForm(i, data){
    const template = document.getElementById('row-template');
    const actionCell = template.querySelector('.actionField');

    const newTd = document.createElement('td');
    newTd.className = 'departmentField';

    const selectInput = document.createElement('div');
    selectInput.className = 'selectInput';
    selectInput.id = "deptInput_" + i;
    
    const selectedLabel = document.createElement('div');
    selectedLabel.className = "selectedLabel";
    selectedLabel.innerHTML =  `
        <label for="">Select A Department (Optional)</label>
        <span class="arrow">
            <svg viewBox="0 0 179 68" xmlns="http://www.w3.org/2000/svg">
                <path d="M1.68164 2.48441L91.8043 63.4844L176.682 2.48441" stroke="black" stroke-width="6"/>
            </svg>
        </span>
    `
    
    const optionContainer = document.createElement('div');
    optionContainer.className = 'optionContainer';
    optionContainer.id = "deptOptions_" + i;

    optionContainer.innerHTML = data.map(department => `
        <div class="option">
            <input type="radio" name="dept" id="${department.dept_id}-${i}" value="${department.dept_id}">
            <label for="${department.dept_id}-${i}">${department.name}</label>
        </div>
    `).join('');

    selectedLabel.addEventListener('click', () => {
        optionContainer.classList.add('active');
    });

    selectInput.appendChild(optionContainer);
    newTd.appendChild(selectInput);

    const row = template.querySelector('tr');
    row.insertBefore(newTd, actionCell);

    return template;
}

function renderTable(role){
    const user_table = document.getElementById('user-table');
    const header = document.querySelector('#user-table thead tr');
    const body = document.querySelector('#form-body');
    const admin_template = document.getElementById('row-template');
    header.innerHTML = '';
    body.innerHTML = '';
    let clone;
    
    const deptData = JSON.parse(document.getElementById('dept-data').textContent);
    const termData = JSON.parse(document.getElementById('term-data').textContent);

    if(role == 1){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="actionField">Action</th>
        `;
        
        clone = admin_template.content.cloneNode(true);
        body.appendChild(clone);
    }

    if(role == 2){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="departmentField">Department</th>
            <th class="actionField">Action</th>
        `;
    }

    if(role == 3){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="intakeField">Intake</th>
            <th class="actionField">Action</th>
        `;
    }
}
