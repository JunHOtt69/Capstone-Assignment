let currentNavDate = new Date();
let selectedStartDate = null;
let rules = {};
let allTermsData = [];
let currentSortColumn = null;
let currentSortDirection = 'asc';

const form = document.querySelector('form');

document.addEventListener('DOMContentLoaded', async function() {
    if (!document.getElementById('tableWrapper')) return;

    const response = await fetch('/get-terms/');
    const data = await response.json();

    const terms_list = data['terms'];
    const rulesArray = data['rules'];

    rulesArray.forEach(r => {
        rules[r.rule_name] = parseInt(r.value_days);
    });

    allTermsData = terms_list;
    renderTable(getFilteredTerms());
    renderOption();
    renderCalendar('Start');

    // Filter listeners
    const searchInput = document.getElementById('termSearchInput');
    const statusFilter = document.getElementById('statusFilterSelect');

    if (searchInput) {
        searchInput.addEventListener('input', () => {
            renderTable(getFilteredTerms());
        });
    }

    if (statusFilter) {
        statusFilter.addEventListener('change', () => {
            renderTable(getFilteredTerms());
        });
    }

    // Edit modal listeners
    const closeBtn = document.getElementById('closeEditModal');
    const cancelBtn = document.getElementById('cancelEditBtn');
    const saveBtn = document.getElementById('saveEditBtn');

    if (closeBtn) closeBtn.addEventListener('click', closeEditModal);
    if (cancelBtn) cancelBtn.addEventListener('click', closeEditModal);
    if (saveBtn) saveBtn.addEventListener('click', saveTermEdit);

    const modal = document.getElementById('editTermModal');
    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) closeEditModal();
        });
    }

    // Delete modal listeners
    const closeDeleteBtn = document.getElementById('closeDeleteModal');
    const cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
    const confirmDeleteBtn = document.getElementById('confirmDeleteBtn');

    if (closeDeleteBtn) closeDeleteBtn.addEventListener('click', closeDeleteModal);
    if (cancelDeleteBtn) cancelDeleteBtn.addEventListener('click', closeDeleteModal);
    if (confirmDeleteBtn) confirmDeleteBtn.addEventListener('click', confirmDeleteTerm);

    const deleteModal = document.getElementById('deleteTermModal');
    if (deleteModal) {
        deleteModal.addEventListener('click', (e) => {
            if (e.target === deleteModal) closeDeleteModal();
        });
    }

    const startDatePickr = this.getElementById('datePickrStart');
    startDatePickr.querySelector('#prevMonthStart').addEventListener('click', (event) => {
        event.stopPropagation();
        currentNavDate.setMonth(currentNavDate.getMonth() - 1);

        updateCalendar('Start', selectedStartDate, (date) => {
            selectedStartDate = date;
            startDateInput.value = date;
            calculateEndDate();
        });
    });

    startDatePickr.querySelector('#nextMonthStart').addEventListener('click', (event) => {
        event.stopPropagation();
        currentNavDate.setMonth(currentNavDate.getMonth() + 1);
        
        updateCalendar('Start', selectedStartDate, (date) => {
            selectedStartDate = date;
            startDateInput.value = date;
            calculateEndDate();
        });
    });
    
    const startDateInput = this.getElementById('id_start_date');
    startDateInput.addEventListener('click', (event) => {
        event.stopPropagation();
        
        const rect = startDateInput.getBoundingClientRect();
        const top = rect.bottom + window.scrollY; 
        const left = rect.left + window.scrollX;

        const calendarEl = this.getElementById('datePickrStart');
        calendarEl.style.top = `${top}px`;
        calendarEl.style.left = `${left}px`;
        calendarEl.classList.add('active');

        updateCalendar('Start',selectedStartDate, (date) => {
            selectedStartDate = date;
            startDateInput.value = date;
            calculateEndDate();
        });
    });
});

document.addEventListener('click', (event) => {
    const allSelect = document.querySelectorAll('.selectInput');
    const allCalendar = document.querySelectorAll('.simple-calendar');
    
    allSelect.forEach(dropdown => {
        if (!dropdown.contains(event.target)) {
            dropdown.classList.remove('active');
        }
    });

    allCalendar.forEach(calendar => {
        if (!calendar.contains(event.target)) {
            calendar.classList.remove('active');
        }
    });
});

if (form) {
    form.addEventListener('submit', (event) => {
        const level = document.getElementById('id_level').value;
        const course = document.getElementById('id_course').value;
        const start = document.getElementById('id_start_date').value;
        const end = document.getElementById('id_end_date').value;

        if (!level || !course || !start || !end) {
            event.preventDefault(); 
            displayError("Error: Please complete all selections before saving.");
            return;
        }
    });
}

window.addEventListener('load', () => {
    const errorEl = document.getElementById('server-errors');
    if (!errorEl) return;
    const raw = errorEl.textContent.trim();
    if (!raw) return;
    const errorData = JSON.parse(raw);
    if (Object.keys(errorData).length > 0) {
        const firstKey = Object.keys(errorData)[0];
        const errorMsg = errorData[firstKey][0].message;
        displayError(`Server Error (${firstKey}): ${errorMsg}`);
    }
});

function renderOption(){
    const levelData = JSON.parse(document.getElementById('level-data').textContent);
    const container = document.getElementById('levelOptions');
    const courseContainer = document.getElementById('courseOptions');
    let level = null;
    let course = null;

    container.innerHTML = levelData.map(level => `
        <div class="option">
            <input type="radio" name="level" id="${level.id}" value="${level.id}">
            <label for="${level.id}">${level.name}</label>
        </div>
    `).join('');

    const selectedLabels = document.querySelectorAll('.selectedLabel');
    selectedLabels.forEach(item => {
        item.addEventListener('click', () => {
            const selectInput = item.closest('.selectInput');
            selectInput.classList.add('active');
        });
    });

    container.addEventListener('change', (event) => {
        if(event.target.type === 'radio'){
            const chosenText = event.target.nextElementSibling.innerText;
            const selectInput = container.closest('.selectInput');
            const selectedLabel = selectInput.querySelector('label');

            selectedLabel.innerText = chosenText;
            selectInput.classList.remove('active');
            
            level = event.target.value;
            fetch(`/get-courses/?level=${level}`)
                .then(response => response.json())
                .then(data => {
                    courseContainer.innerHTML = '';
                    data.forEach(item => {
                        courseContainer.innerHTML += `
                            <div class="option">
                                <input type="radio" name="course" id="${item.course_id}" value="${item.course_id}" data-weeks="${item.semester_week}">
                                <label for="${item.course_id}">
                                    ${item.course_code}-
                                    ${item.course_name}
                                </label>
                            </div>    
                        `;
                    });
                });

            document.getElementById('id_level').value = event.target.value;

            const courseInput = document.getElementById('courseInput');
            courseInput.classList.remove('inactive');
            courseInput.classList.add('active');
        }
    });
    courseContainer.addEventListener('change', (event) => {
        if(event.target.type === 'radio'){
            const chosenText = event.target.nextElementSibling.innerText;
            const selectInput = courseContainer.closest('.selectInput');
            const selectedLabel = selectInput.querySelector('label');
            
            document.getElementById('id_course').value = event.target.value;
            selectedLabel.innerText = chosenText;
            selectInput.classList.remove('active');

            const weeks = event.target.getAttribute('data-weeks');
            const weeksTaken = document.querySelector('form .courseInfo #weeksTaken');
            const swdField = document.querySelector('form .courseInfo #studyWeek');
            const epFIeld = document.querySelector('form .courseInfo #examinationPeriod');

            if(weeksTaken){
                weeksTaken.innerHTML = `Week Taken: <strong>${weeks}</strong>`;
            }

            if(swdField){
                swdField.innerHTML = `Study Week: <strong>${rules['Study Weeks'] || 0} days</strong>`;
            }

            if(epFIeld){
                epFIeld.innerHTML = `Examination Period: <strong>${rules['Examination Period'] || 0} days</strong>`;
            }
            calculateEndDate();
        }
    });
}

function getFilteredTerms() {
    let filtered = [...allTermsData];
    const searchInput = document.getElementById('termSearchInput');
    const statusFilter = document.getElementById('statusFilterSelect');

    if (searchInput && searchInput.value.trim()) {
        const query = searchInput.value.trim().toLowerCase();
        filtered = filtered.filter(t =>
            t.intake_code.toLowerCase().includes(query) ||
            t.course__course_name.toLowerCase().includes(query)
        );
    }

    if (statusFilter && statusFilter.value !== 'all') {
        const isActive = statusFilter.value === 'active';
        filtered = filtered.filter(t => t.is_active === isActive);
    }

    if (currentSortColumn) {
        filtered.sort((a, b) => {
            let valA = a[currentSortColumn];
            let valB = b[currentSortColumn];

            if (currentSortColumn === 'is_active') {
                valA = valA ? 1 : 0;
                valB = valB ? 1 : 0;
            } else if (typeof valA === 'string') {
                valA = valA.toLowerCase();
                valB = valB.toLowerCase();
            }

            if (valA < valB) return currentSortDirection === 'asc' ? -1 : 1;
            if (valA > valB) return currentSortDirection === 'asc' ? 1 : -1;
            return 0;
        });
    }

    return filtered;
}

function handleSort(column) {
    if (currentSortColumn === column) {
        currentSortDirection = currentSortDirection === 'asc' ? 'desc' : 'asc';
    } else {
        currentSortColumn = column;
        currentSortDirection = 'asc';
    }
    renderTable(getFilteredTerms());
}

function getSortIndicator(column) {
    if (currentSortColumn !== column) return '';
    return currentSortDirection === 'asc' ? ' ▲' : ' ▼';
}

function renderTable(data) {
    const tableWrapper = document.querySelector('#tableWrapper');
    const existingTable = tableWrapper.querySelector('table');
    const existingEmpty = tableWrapper.querySelector('.emptyMessage');
    if (existingTable) existingTable.remove();
    if (existingEmpty) existingEmpty.remove();

    if(data.length > 0){
        const table = document.createElement('table');
        table.id = 'termsList';

        const thead = document.createElement('thead');
        thead.innerHTML = `
            <th class="no-col">No.</th>
            <th class="intake sortable" data-sort="intake_code">Intake Code${getSortIndicator('intake_code')}</th>
            <th class="course sortable" data-sort="course__course_name">Course${getSortIndicator('course__course_name')}</th>
            <th class="semester sortable" data-sort="current_semester">Current Semester${getSortIndicator('current_semester')}</th>
            <th class="date sortable" data-sort="start_date">Start Date${getSortIndicator('start_date')}</th>
            <th class="date sortable" data-sort="end_date">End Date${getSortIndicator('end_date')}</th>
            <th class="status sortable" data-sort="is_active">Status${getSortIndicator('is_active')}</th>
            <th class="action">Action</th>
        `;

        thead.querySelectorAll('.sortable').forEach(th => {
            th.addEventListener('click', () => {
                handleSort(th.dataset.sort);
            });
        });

        const tbody = document.createElement('tbody');
        tbody.innerHTML = '';
        
        data.forEach(term => {
            const row = `
                <tr>
                    <td class="number-cell"></td>
                    <td class="intake">${term.intake_code}</td>
                    <td class="course"><span>${term.course__course_name}</span></td>
                    <td class="semester">${term.current_semester}</td>
                    <td class="date">${term.start_date}</td>
                    <td class="date">${term.end_date}</td>
                    <td class="status"><span class="status ${term.is_active ? 'active' : 'inactive'}">${term.is_active ? 'Active' : 'Inactive'}</span></td>
                    <td class="action">
                        <div class="inputWrapper">
                            <button type="button" class="editBtn" onclick="openEditModal(${term.term_id})">
                            <svg id="Capa_1" viewBox="0 0 528.899 528.899">
                                <g>
                                    <path d="M328.883,89.125l107.59,107.589l-272.34,272.34L56.604,361.465L328.883,89.125z M518.113,63.177l-47.981-47.981
                                        c-18.543-18.543-48.653-18.543-67.259,0l-45.961,45.961l107.59,107.59l53.611-53.611
                                        C532.495,100.753,532.495,77.559,518.113,63.177z M0.3,512.69c-1.958,8.812,5.998,16.708,14.811,14.565l119.891-29.069
                                        L27.473,390.597L0.3,512.69z"/>
                                </g>
                                </svg>
                            </button>
                            <button type="button" class="deleteBtn" onclick="openDeleteModal(${term.term_id})">
                                <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                                    <path d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                                </svg>
                            </button>
                        </div>
                    </td>
                </tr>
            `;
            tbody.innerHTML += row;
        }); 

        table.appendChild(thead);
        table.appendChild(tbody);
        tableWrapper.appendChild(table);
    }
    else{
        const emptyMessage = document.createElement('p');
        emptyMessage.className = 'emptyMessage'
        emptyMessage.innerHTML = 'No academic terms match the current filters.'
        
        tableWrapper.appendChild(emptyMessage);
    }
}

function openEditModal(termId) {
    const term = allTermsData.find(t => t.term_id === termId);
    if (!term) return;

    document.getElementById('editTermId').value = term.term_id;
    document.getElementById('editIntakeCode').textContent = term.intake_code;
    document.getElementById('editCourseName').textContent = term.course__course_name;
    document.getElementById('editSemester').value = term.current_semester;
    document.getElementById('editStartDate').value = term.start_date;
    document.getElementById('editEndDate').value = term.end_date;
    document.getElementById('editStatus').value = term.is_active ? 'true' : 'false';
    document.getElementById('editError').textContent = '';

    document.getElementById('editTermModal').classList.add('active');
}

function closeEditModal() {
    document.getElementById('editTermModal').classList.remove('active');
}

async function saveTermEdit() {
    const termId = document.getElementById('editTermId').value;
    const semester = document.getElementById('editSemester').value;
    const startDate = document.getElementById('editStartDate').value;
    const endDate = document.getElementById('editEndDate').value;
    const isActive = document.getElementById('editStatus').value === 'true';
    const errorEl = document.getElementById('editError');
    errorEl.textContent = '';

    if (!semester || parseInt(semester) < 1) {
        errorEl.textContent = 'Semester must be at least 1.';
        return;
    }
    if (!startDate || !endDate) {
        errorEl.textContent = 'Both dates are required.';
        return;
    }
    if (startDate >= endDate) {
        errorEl.textContent = 'End date must be after start date.';
        return;
    }

    const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]').value;

    try {
        const response = await fetch('/update-term/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': csrfToken,
            },
            body: JSON.stringify({
                term_id: parseInt(termId),
                current_semester: parseInt(semester),
                start_date: startDate,
                end_date: endDate,
                is_active: isActive
            })
        });

        const result = await response.json();
        if (result.success) {
            const term = allTermsData.find(t => t.term_id === parseInt(termId));
            if (term) {
                term.current_semester = parseInt(semester);
                term.start_date = startDate;
                term.end_date = endDate;
                term.is_active = isActive;
            }
            closeEditModal();
            renderTable(getFilteredTerms());
            showNotif('success', 'Academic term updated successfully!');
        } else {
            errorEl.textContent = result.error || 'Failed to update term.';
            showNotif('error', result.error || 'Failed to update term.');
        }
    } catch (err) {
        errorEl.textContent = 'Network error. Please try again.';
        showNotif('error', 'Network error. Please try again.');
    }
}

function openDeleteModal(termId) {
    const term = allTermsData.find(t => t.term_id === termId);
    if (!term) return;

    document.getElementById('deleteTermId').value = term.term_id;
    document.getElementById('deleteIntakeCode').textContent = term.intake_code;
    document.getElementById('deleteCourseName').textContent = term.course__course_name;
    document.getElementById('deleteError').textContent = '';

    document.getElementById('deleteTermModal').classList.add('active');
}

function closeDeleteModal() {
    document.getElementById('deleteTermModal').classList.remove('active');
}

async function confirmDeleteTerm() {
    const termId = document.getElementById('deleteTermId').value;
    const errorEl = document.getElementById('deleteError');
    errorEl.textContent = '';

    const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]').value;

    try {
        const response = await fetch('/delete-term/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': csrfToken,
            },
            body: JSON.stringify({ term_id: parseInt(termId) })
        });

        const result = await response.json();
        if (result.success) {
            allTermsData = allTermsData.filter(t => t.term_id !== parseInt(termId));
            closeDeleteModal();
            renderTable(getFilteredTerms());
            showNotif('success', 'Academic term deleted successfully!');
        } else {
            errorEl.textContent = result.error || 'Failed to delete term.';
            showNotif('error', result.error || 'Failed to delete term.');
        }
    } catch (err) {
        errorEl.textContent = 'Network error. Please try again.';
        showNotif('error', 'Network error. Please try again.');
    }
}

function renderCalendar(i){
    const calendar = document.createElement('div');
    calendar.classList.add('simple-calendar');
    calendar.id = `datePickr${i}`;

    const cal_header = document.createElement('div');
    cal_header.classList.add('cal-header');

    const prevMonthBtn = document.createElement('button');
    prevMonthBtn.id = `prevMonth${i}`;
    prevMonthBtn.classList.add('prevMonth');
    prevMonthBtn.innerHTML = '&lt;';

    const nextMonthBtn = document.createElement('button');
    nextMonthBtn.id = `nextMonth${i}`;
    nextMonthBtn.classList.add('nextMonth');
    nextMonthBtn.innerHTML = '&gt;';

    const monthDisplay = document.createElement('p');
    monthDisplay.id = `monthDisplay${i}`;

    cal_header.appendChild(prevMonthBtn);
    cal_header.appendChild(monthDisplay);
    cal_header.appendChild(nextMonthBtn);

    const cal_weekdays = document.createElement('div');
    cal_weekdays.classList.add('cal-weekdays');
    cal_weekdays.innerHTML = `
        <div>Sun</div>
        <div>Mon</div>
        <div>Tue</div>
        <div>Wed</div>
        <div>Thu</div>
        <div>Fri</div>
        <div>Sat</div>
    `;

    const daysGrid = document.createElement('div');
    daysGrid.classList.add('cal-days');
    daysGrid.id = `daysGrid${i}`;

    calendar.appendChild(cal_header);
    calendar.appendChild(cal_weekdays);
    calendar.appendChild(daysGrid);
    document.body.appendChild(calendar);
}

function updateCalendar(i, selectedDate, onSelect) {
    const calendar = document.getElementById(`datePickr${i}`);
    const daysGrid = document.getElementById(`daysGrid${i}`);
    const monthDisplay = document.getElementById(`monthDisplay${i}`);

    const year = currentNavDate.getFullYear();
    const month = currentNavDate.getMonth();
    monthDisplay.innerText = currentNavDate.toLocaleString('default', { month: 'long', year: 'numeric' });

    const firstDayIndex = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate(); 
    
    daysGrid.innerHTML = '';

    for (let i = 0; i < firstDayIndex; i++) {
        const emptyDiv = document.createElement('div');
        emptyDiv.classList.add('cal-day', 'empty');
        daysGrid.appendChild(emptyDiv);
    }

    for (let day = 1; day <= daysInMonth; day++) {
        const dayDiv = document.createElement('div');
        dayDiv.classList.add('cal-day');
        dayDiv.innerText = day;
        
        const today = new Date();
        if (day === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
            dayDiv.classList.add('today');
        }
        if(selectedDate) {
            const [y, m, d] = selectedDate.split('-');
            const s_y = parseInt(y);
            const s_m = parseInt(m) - 1;
            const s_d = parseInt(d);

            if (day === s_d && month === s_m && year === s_y) {
                dayDiv.classList.add('selected');
            }
        }

        dayDiv.addEventListener('click', () => {
            const currentSelected = daysGrid.querySelector('.cal-day.selected');
            if (currentSelected) {
                currentSelected.classList.remove('selected');
            }

            dayDiv.classList.add('selected');
            calendar.classList.remove('active');
            const formattedDate = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            
            onSelect(formattedDate);
        });
        
        daysGrid.appendChild(dayDiv);
    }
}

function calculateEndDate(){
    if(!document.querySelector('#courseInput .option:has(input:checked) input')) return;

    const course = document.querySelector('#courseInput .option:has(input:checked) input');
    const startDateInput = document.getElementById('id_start_date');
    const endDateInput = document.getElementById('id_end_date');

    if(course && startDateInput.value != ''){
        let studyWeekDays  = null;
        let examinationPeriod = null;

        const swdField = document.querySelector('form .courseInfo #studyWeek');
        const epFIeld = document.querySelector('form .courseInfo #examinationPeriod');

        studyWeekDays = rules['Study Weeks'] || 0;
        examinationPeriod = rules['Examination Period'] || 0;

        const weeks = parseInt(course.dataset.weeks);
        let date = new Date(startDateInput.value);
        let totalStudyDays = 7 * weeks + studyWeekDays + examinationPeriod;

        date.setDate(date.getDate() + totalStudyDays);
        const y = date.getFullYear();
        const m = String(date.getMonth() + 1).padStart(2, '0');
        const d = String(date.getDate()).padStart(2, '0');

        const formattedEndDate = `${y}-${m}-${d}`;

        endDateInput.value = formattedEndDate;
    }
}
    
function displayError(text) {
    const errorMessageContainer = document.querySelector('.errorMessage');
    errorMessageContainer.innerHTML = '';
    const message = document.createElement('p');
    message.style.color = "red";
    message.innerHTML = text;
    errorMessageContainer.appendChild(message);
}