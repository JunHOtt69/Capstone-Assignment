const addBtn = document.getElementById('add-row-btn');


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
    const admin_template = document.getElementById('row-template-admin');
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


function renderTable(role){
    const user_table = document.getElementById('user-table');
    const header = document.querySelector('#user-table thead tr');
    const body = document.querySelector('#form-body');
    const admin_template = document.getElementById('row-template-admin');
    header.innerHTML = '';
    body.innerHTML = '';
    let clone;
    
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
