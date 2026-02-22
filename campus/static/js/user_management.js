const addBtn = document.getElementById('add-row-btn');

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

    if (hasData && !isSubmitting) {
        event.preventDefault();
        event.returnValue = ''; 
    }
});

document.addEventListener('DOMContentLoaded', async function() {
    lecRow = 0;
    stuRow = 0;
    const user_role = document.getElementById('id_user_role');
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);
    const form = document.querySelector('form');
    if(form){
        form.addEventListener('submit', () => {
            isSubmitting = true;
        })
    }

    const roleContext = document.getElementById('role-context');
    const savedRole = roleContext ? JSON.parse(roleContext.textContent) : null;

    function attemptRoleSwitch(role){
        if(checkEmpty()){
            user_role.value = role;
            renderTable(user_role.value);
        }
    }

    document.getElementById('admin_role').onclick = () => attemptRoleSwitch(groupData['admin']);
    document.getElementById('lecturer_role').onclick = () => attemptRoleSwitch(groupData['lecturer']);
    document.getElementById('student_role').onclick = () => attemptRoleSwitch(groupData['student']);

    if(savedRole){
        user_role.value = savedRole;
    }
    else{
        user_role.value = groupData['admin'];
    }

    renderTable(user_role.value);
});

document.addEventListener('click', (event) => {
    const allSelect = document.querySelectorAll('.selectInput');
    
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

function checkEmpty(){
    const inputs = document.querySelectorAll('#form-body input');
    const hasData = Array.from(inputs).some(input => {
        if(input.type === 'radio' || input.type === 'checkbox'){
            return input.checked;
        }

        return input.value.trim() !== '';
    });

    if (hasData){
        const userConfirmed = confirm("You have unsaved changes. Are you sure you want to switch roles?");
        return userConfirmed;
    }

    return true;
}

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

    else if(role == groupData['lecturer']){
        user_role_button.classList.remove('admin');
        user_role_button.classList.remove('student');
        user_role_button.classList.add('lecturer');
    }

    else if(role == groupData['student']){
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

function renderLecturerForm(i, data, initialValue){
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

    optionContainer.innerHTML = data.map(department => {
        const isChecked = (initialValue && String(department.dept_id) === String(initialValue)) ? 'checked' : '';
        
        return `
            <div class="option">
                <input type="radio" name="temp_radio_${i}" id="${department.dept_id}-${i}" value="${department.dept_id}" ${isChecked}>
                <label for="${department.dept_id}-${i}">${department.dept_name}</label>
            </div>
        `;
    }).join('');

    if (initialValue) {
        const selectedDept = data.find(d => String(d.dept_id) === String(initialValue));
        if (selectedDept) {
            departmentCell.querySelector('.selectedLabel label').innerText = selectedDept.dept_name;
            djangoHiddenInput.value = initialValue;
        }
    }

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

function renderStudentForm(i, data, initialValue){
    const template = document.getElementById('row-template');
    const clone_template  = template.content.cloneNode(true);
    const row = clone_template.querySelector('tr');
    row.classList.add('studentUser');
    const actionCell = row.querySelector('.actionField');

    const _input = document.getElementById('termInput').content.cloneNode(true);
    const termCell = _input.querySelector('td');

    const djangoHiddenInput = termCell.querySelector('input[type="hidden"]');
    if (djangoHiddenInput) {
        djangoHiddenInput.name = "term_" + i; 
        djangoHiddenInput.id = "id_term_" + i;
    }

    const selectInput = termCell.querySelector('.selectInput');
    const selectedLabel = termCell.querySelector('.selectedLabel');
    const optionContainer = termCell.querySelector('.optionContainer');

    optionContainer.innerHTML = data.map(term => {
        const isChecked = (initialValue && String(term.term_id) === String(initialValue)) ? 'checked' : '';
        
        return `
            <div class="option">
                <input type="radio" name="temp_radio_${i}" id="${term.term_id}-${i}" value="${term.term_id}" ${isChecked}>
                <label for="${term.term_id}-${i}">${term.intake_code}</label>
            </div>
        `;
    }).join('');

    if (initialValue) {
        const selectedTerm = data.find(d => String(d.term_id) === String(initialValue));
        if (selectedTerm) {
            termCell.querySelector('.selectedLabel label').innerText = selectedTerm.intake_code;
            djangoHiddenInput.value = initialValue;
        }
    }

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
    const header = document.querySelector('#user-table thead tr');
    const body = document.querySelector('#form-body');

    renderRoleButton(role);

    
    const deptData = JSON.parse(document.getElementById('dept-data').textContent);
    const termData = JSON.parse(document.getElementById('term-data').textContent);
    const groupData = JSON.parse(document.getElementById('groups-data').textContent);
    const savedOpts = JSON.parse(document.getElementById('selected-opts-data').textContent || '[]');

    const rowCountContext = document.getElementById('row-count-data'); // Add this to HTML
    const savedRowCount = rowCountContext ? JSON.parse(rowCountContext.textContent) : 0;
    const existingRowsCount = document.getElementsByName('first_name').length;
    
    const rowsToCreate = Math.max(savedRowCount, existingRowsCount, 1);

    header.innerHTML = '';
    body.innerHTML = '';
    lecRow = 0;
    stuRow = 0;

    if(role == groupData['admin']){
        header.innerHTML = `
            <th class="no-col">No.</th>
            <th class="f-nField">First Name</th>
            <th class="l-nField">Last Name</th>
            <th class="emailField">Email</th>
            <th class="actionField">Action</th>
        `;
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
    }

    

    for(let i = 1; i <= rowsToCreate; i++){
        let row;

        if(role == groupData['admin']){
            row = renderAdminForm();
        }

        else if(role == groupData['lecturer']){
            lecRow += 1;
            row = renderLecturerForm(lecRow, deptData, savedOpts[i-1]);
        }

        else if(role == groupData['student']){
            stuRow += 1;
            row = renderStudentForm(stuRow, termData, savedOpts[i-1]);
        }

        body.appendChild(row);
    }
}
