document.addEventListener('DOMContentLoaded', function() {
    const monthYearDisplay = document.getElementById('monthYearDisplay');
    const calendarGrid = document.getElementById('calendarGrid');
    const prevBtn = document.getElementById('prevMonth');
    const nextBtn = document.getElementById('nextMonth');

    const emptyMsg = document.querySelector('.classInfo .empty');
    const attendanceWrap = document.querySelector('.attendanceWrap');
    const classDetails = document.querySelector('.classDetails');
    const rateH3 = document.querySelector('.attendanceRate h3');
    const tagTotal = document.querySelector('.tag.total');
    const tagPresent = document.querySelector('.tag.present');
    const tagLate = document.querySelector('.tag.late');
    const tagAbsent = document.querySelector('.tag.absent');
    const editBtn = document.querySelector('.editSession');
    const tableBody = document.querySelector('.table-container tbody');

    if(attendanceWrap) attendanceWrap.classList.add('hide');
    if(classDetails) classDetails.classList.add('hide');
    emptyMsg.classList.remove('hide');
    let currentDate = new Date();

    function renderCalendar() {
        const year = currentDate.getFullYear();
        const month = currentDate.getMonth();
        monthYearDisplay.innerText = `${currentDate.toLocaleString('default', { month: 'long' })} ${year}`;
        calendarGrid.innerHTML = '';

        const firstDayIndex = new Date(year, month, 1).getDay();
        const lastDay = new Date(year, month + 1, 0).getDate();

        const datesWithClasses = pastClasses.map(c => c.date);
        for (let i = 0; i < firstDayIndex; i++) {
            const emptyDiv = document.createElement('div');
            emptyDiv.classList.add('calendar-date', 'empty');
            calendarGrid.appendChild(emptyDiv);
        }

        for (let day = 1; day <= lastDay; day++) {
            const dateDiv = document.createElement('div');
            dateDiv.classList.add('calendar-date');
            dateDiv.innerText = day;

            const cellDate = `${year}-${String(month + 1).padStart(2, '0')}-${String(day).padStart(2, '0')}`;

            const classData = pastClasses.find(c => c.date === cellDate);
            
            if (classData && datesWithClasses.includes(cellDate)){
                dateDiv.classList.add('have-class');
                if (classData.status === 'ABSENT') {
                    dateDiv.classList.add('absent-date');
                }
            }
                

            dateDiv.addEventListener('click', function() {
                const isAlreadyActive = this.classList.contains('active');

                document.querySelectorAll('.calendar-date').forEach(el => el.classList.remove('active'));

                if (classData && !isAlreadyActive) {
                    this.classList.add('active');
                    updateClassInfo(classData);
                } else {
                    emptyMsg.classList.remove('hide');
                    if(attendanceWrap) attendanceWrap.classList.add('hide');
                    if(classDetails) classDetails.classList.add('hide');
                }
            });

            const today = new Date();
            if (day === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
                dateDiv.classList.add('today');
            }

            calendarGrid.appendChild(dateDiv);
        }
    }

    prevBtn.addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() - 1);
        renderCalendar();
    });

    nextBtn.addEventListener('click', () => {
        currentDate.setMonth(currentDate.getMonth() + 1);
        renderCalendar();
    });

    function updateClassInfo(data) {
        if(user_role == "lecturer"){
            emptyMsg.classList.add('hide');
            attendanceWrap.classList.remove('hide');

            rateH3.innerText = `${data.att_rate}%`;
            tagTotal.innerHTML = `Total: ${data.present + data.late + data.absent}`;
            tagPresent.innerHTML = `Present: ${data.present}`;
            tagLate.innerHTML = `Late: ${data.late}`;
            tagAbsent.innerHTML = `Absent: ${data.absent}`;

            const dynamicForm = document.getElementById('auto-open-form-template');

            dynamicForm.action = `/attendance/lecturer-otp/${data.id}/`;

            document.getElementById('hidden_intake').value = intake_code;
            document.getElementById('hidden_subject').value = subject_id;

            const dynamicEditBtn = document.getElementById('dynamicEditBtn');
            dynamicEditBtn.onclick = function() {
                dynamicForm.submit();
            };

            
            tableBody.innerHTML = ''; 
            if (data.absent_list.length > 0) {
                data.absent_list.forEach(student => {
                    const row = `
                        <tr>
                            <td class="number-cell"></td>
                            <td><p class="id">${student.id}</p></td>
                            <td><p class="name">${student.name}</p></td>
                        </tr>
                    `;
                    tableBody.insertAdjacentHTML('beforeend', row);
                });
            } else {
                tableBody.innerHTML = '<tr><td colspan="3">No absent students.</td></tr>';
            }
        }
        else if (user_role == "student"){
            emptyMsg.classList.add('hide');
            classDetails.classList.remove('hide');

            document.querySelector('.classNameDisplay').innerText = data.class_name;
            document.querySelector('.classTypeDisplay').innerText = data.class_type;
            document.querySelector('.startTime').innerText = data.start_time;
            document.querySelector('.endTime').innerText = data.end_time;
            document.querySelector('.facilityName').innerText = data.facility;
            document.querySelector('.lecturerNameDisplay').innerText = data.lecturer;

            const statusTag = document.querySelector('.tag');
            statusTag.innerText = data.status;
            
            statusTag.classList.add(data.status.toLowerCase());
        }
    }

    renderCalendar();
});