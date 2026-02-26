let currentNavDate = new Date();
let selectedStartDate = null;
let rules = {};

const form = document.querySelector('form');

document.addEventListener('DOMContentLoaded', async function() {
    const response = await fetch('/get-terms/');
    const data = await response.json();

    const terms_list = data['terms'];
    const rulesArray = data['rules'];

    rulesArray.forEach(r => {
        rules[r.rule_name] = parseInt(r.value_days);
    });

    renderTable(terms_list);
    renderOption();
    renderCalendar('Start');

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

window.addEventListener('load', () => {
    const errorData = JSON.parse(document.getElementById('server-errors').textContent);
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

function renderTable(data) {
    const tableWrapper = document.querySelector('#tableWrapper');
    if(data.length > 0){
        const table = document.createElement('table');
        table.id = 'termsList';

        const thead = document.createElement('thead');
        thead.innerHTML = `
            <th class="no-col">No.</th>
            <th class="intake">Intake Code</th>
            <th class="course">Course</th>
            <th class="semester">Current Semester</th>
            <th class="date">Start Date</th>
            <th class="date">End Date</th>
            <th class="status">Status</th>
            <th class="action">Action</th>
        `;

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
                    <td class="status"><span class="status">${term.is_active ? 'Active' : 'Inactive'}</span></td>
                    <td class="action">
                        <div class="inputWrapper">
                            <button type="button">
                            <svg id="Capa_1" viewBox="0 0 528.899 528.899">
                                <g>
                                    <path d="M328.883,89.125l107.59,107.589l-272.34,272.34L56.604,361.465L328.883,89.125z M518.113,63.177l-47.981-47.981
                                        c-18.543-18.543-48.653-18.543-67.259,0l-45.961,45.961l107.59,107.59l53.611-53.611
                                        C532.495,100.753,532.495,77.559,518.113,63.177z M0.3,512.69c-1.958,8.812,5.998,16.708,14.811,14.565l119.891-29.069
                                        L27.473,390.597L0.3,512.69z"/>
                                </g>
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
        emptyMessage.innerHTML = 'Do not have any academic term available yet. Try to create one.'
        
        tableWrapper.appendChild(emptyMessage);
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