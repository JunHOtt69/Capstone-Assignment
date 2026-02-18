let currentNavDate = new Date();

function renderCalendar(i){
    const calendar = document.createElement('div');
    calendar.classList.add('simple-calendar');
    calendar.id = `datePickr${i}`;

    const cal_header = document.createElement('div');
    cal_header.classList.add('cal-header');

    const prevMonthBtn = document.createElement('button');
    prevMonthBtn.id = `prevMonth${i}`;
    prevMonthBtn.innerHTML = '&lt;';

    const nextMonthBtn = document.createElement('button');
    nextMonthBtn.id = `nextMonth${i}`;
    nextMonthBtn.innerHTML = '&lt;';

    const monthDisplay = document.createElement('h5');
    monthDisplay.id = `monthDisplay${i}`;

    cal-header.appendChild(prevMonthBtn);
    cal-header.appendChild(monthDisplay);
    cal-header.appendChild(nextMonthBtn);
    const cal_weekdays = document.createElement('div');
    cal_weekdays.innerHtml = `
        <div>Sun</div><div>Mon</div><div>Tue</div><div>Wed</div>
        <div>Thu</div><div>Fri</div><div>Sat</div>
    `;

    const daysGrid = document.createElement('div');
    daysGrid.classList.add('cal-days');
    daysGrid.id = `daysGrid${i}`;
    
    updateCalendar(i);

    prevMonthBtn.addEventListener('click', () => {
        currentNavDate.setMonth(currentNavDate.getMonth() - 1);
        updateCalendar(i);
    });

    nextMonthBtn.addEventListener('click', () => {
        currentNavDate.setMonth(currentNavDate.getMonth() + 1);
        updateCalendar(i);
    });
}

function updateCalendar(i) {
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

        dayDiv.addEventListener('click', () => {
            const currentSelected = daysGrid.querySelector('.cal-day.selected');
            if (currentSelected) {
                currentSelected.classList.remove('selected');
            }

            dayDiv.classList.add('selected');

            const formattedDate = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
            console.log(`Date selected: ${formattedDate}`);
            
            document.getElementById('id_start_date').value = formattedDate;
        });
        
        daysGrid.appendChild(dayDiv);
    }
}