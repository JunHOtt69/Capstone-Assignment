/* ============================================================
   VIEW TIMETABLE — read-only timetable for students & lecturers
   ============================================================ */
document.addEventListener('DOMContentLoaded', function () {
    const termDropdown = document.getElementById('termDropdown');
    const termOptions  = document.getElementById('termOptions');
    const weekNav      = document.getElementById('weekNav');
    const prevWeekBtn  = document.getElementById('prevWeekBtn');
    const nextWeekBtn  = document.getElementById('nextWeekBtn');
    const weekLabel    = document.getElementById('weekLabel');
    const timetableGrid = document.getElementById('timetableGrid');
    const timetableBody = document.getElementById('timetableBody');

    let selectedTermId   = null;
    let currentWeekMonday = null;
    let termStart = null;
    let termEnd   = null;

    /* ── Date helpers (same as admin timetable.js) ── */

    function parseParts(s) {
        const p = s.split('-');
        return { y: +p[0], m: +p[1], d: +p[2] };
    }

    function daysInMonth(y, m) {
        return new Date(y, m, 0).getDate();
    }

    function addDays(dateStr, n) {
        const p = parseParts(dateStr);
        let y = p.y, m = p.m, d = p.d + n;
        while (d > daysInMonth(y, m)) { d -= daysInMonth(y, m); m++; if (m > 12) { m = 1; y++; } }
        while (d < 1) { m--; if (m < 1) { m = 12; y--; } d += daysInMonth(y, m); }
        return `${y}-${String(m).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
    }

    function getMondayOfWeek(dateStr) {
        const dt = new Date(dateStr + 'T12:00:00');
        const dow = dt.getDay();
        const offset = dow === 0 ? -6 : 1 - dow;
        return addDays(dateStr, offset);
    }

    function formatDate(dateStr) {
        const p = parseParts(dateStr);
        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        return `${p.d} ${months[p.m - 1]} ${p.y}`;
    }

    function getWeekNumber(mondayStr, termStartStr) {
        const m = new Date(mondayStr + 'T12:00:00');
        const s = new Date(getMondayOfWeek(termStartStr) + 'T12:00:00');
        const diff = Math.round((m - s) / (7 * 864e5));
        return diff + 1;
    }

    function cmpDate(a, b) { return a < b ? -1 : a > b ? 1 : 0; }

    /* ── Week navigation ── */

    function updateWeekNav() {
        if (!currentWeekMonday || !termStart || !termEnd) return;
        const friday = addDays(currentWeekMonday, 4);
        const weekNum = getWeekNumber(currentWeekMonday, termStart);
        weekLabel.textContent = `Week ${weekNum}  ·  ${formatDate(currentWeekMonday)} — ${formatDate(friday)}`;

        const termMonday = getMondayOfWeek(termStart);
        prevWeekBtn.disabled = cmpDate(currentWeekMonday, termMonday) <= 0;

        const lastMonday = getMondayOfWeek(termEnd);
        nextWeekBtn.disabled = cmpDate(currentWeekMonday, lastMonday) >= 0;
    }

    prevWeekBtn.addEventListener('click', function () {
        const termMonday = getMondayOfWeek(termStart);
        const candidate = addDays(currentWeekMonday, -7);
        if (cmpDate(candidate, termMonday) < 0) return;
        currentWeekMonday = candidate;
        updateWeekNav();
        loadTimetable();
    });

    nextWeekBtn.addEventListener('click', function () {
        const lastMonday = getMondayOfWeek(termEnd);
        const candidate = addDays(currentWeekMonday, 7);
        if (cmpDate(candidate, lastMonday) > 0) return;
        currentWeekMonday = candidate;
        updateWeekNav();
        loadTimetable();
    });

    /* ── Term selection ── */

    function initTerm(termId, start, end) {
        selectedTermId = termId;
        termStart = start;
        termEnd = end;

        // Start on the current week (clamped to term bounds)
        const today = new Date();
        const todayStr = `${today.getFullYear()}-${String(today.getMonth()+1).padStart(2,'0')}-${String(today.getDate()).padStart(2,'0')}`;
        let monday = getMondayOfWeek(todayStr);
        const termMonday = getMondayOfWeek(termStart);
        const lastMonday = getMondayOfWeek(termEnd);
        if (cmpDate(monday, termMonday) < 0) monday = termMonday;
        if (cmpDate(monday, lastMonday) > 0) monday = lastMonday;
        currentWeekMonday = monday;

        weekNav.style.display = 'flex';
        timetableGrid.style.display = 'block';
        updateWeekNav();
        loadTimetable();
    }

    // Multi-term dropdown
    if (termDropdown) {
        termDropdown.querySelector('.selectedLabel').addEventListener('click', function () {
            termDropdown.classList.add('active');
        });

        termOptions.addEventListener('change', function (e) {
            if (e.target.type !== 'radio') return;
            var chosenText = e.target.nextElementSibling.innerText;
            termDropdown.querySelector('.selectedLabel label').innerText = chosenText;
            termDropdown.classList.remove('active');
            initTerm(e.target.value, e.target.getAttribute('data-start'), e.target.getAttribute('data-end'));
        });
    }

    // Single term (student) — auto-load
    const singleInput = document.getElementById('singleTermId');
    if (singleInput) {
        initTerm(singleInput.value, singleInput.getAttribute('data-start'), singleInput.getAttribute('data-end'));
    }

    // Lecturer mode — auto-load without term selection
    const lecturerMode = document.getElementById('lecturerMode');
    if (lecturerMode) {
        initTerm(null, lecturerMode.getAttribute('data-start'), lecturerMode.getAttribute('data-end'));
    }

    /* ── Load & render ── */

    function loadTimetable() {
    // 1. Guard against null or "NaN" strings
        if (!currentWeekMonday || currentWeekMonday.includes('NaN')) {
            console.warn("Skipping load: currentWeekMonday is invalid.", currentWeekMonday);
            return; 
        }
        
        if (selectedTermId === null && !document.getElementById('lecturerMode')) return;

        let url = `/timetable/data/?week_start=${encodeURIComponent(currentWeekMonday)}`;
        if (selectedTermId) url += `&term_id=${encodeURIComponent(selectedTermId)}`;

        fetch(url)
            .then(r => {
                if (!r.ok) throw new Error(`Server responded with ${r.status}`);
                return r.json();
            })
            .then(data => {
                if (data.error) {
                    showNotif('error', data.error);
                    return;
                }
                renderTimetable(data.timetable);
            })
            .catch(err => {
                console.error(err);
                showNotif('error', 'Failed to load timetable');
            });
    }

    function renderTimetable(sessions) {
        timetableBody.innerHTML = '';

        const slotMap = {};
        sessions.forEach(s => {
            const key = s.start_time + '-' + s.end_time;
            if (!slotMap[key]) slotMap[key] = { start: s.start_time, end: s.end_time };
        });

        const timeSlots = Object.values(slotMap).sort((a, b) => a.start.localeCompare(b.start));

        if (timeSlots.length === 0) {
            timetableBody.innerHTML = '<tr><td colspan="6" class="emptySlot">No classes scheduled for this week.</td></tr>';
            return;
        }

        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

        timeSlots.forEach(slot => {
            const row = document.createElement('tr');
            const timeCell = document.createElement('td');
            timeCell.textContent = slot.start + ' - ' + slot.end;
            timeCell.style.fontWeight = '600';
            row.appendChild(timeCell);

            days.forEach(day => {
                const td = document.createElement('td');
                const matching = sessions.filter(s => s.day === day && s.start_time === slot.start && s.end_time === slot.end);

                if (matching.length > 0) {
                    matching.forEach(m => {
                        const div = document.createElement('div');
                        let cellClass = 'sessionCell';
                        if (m.class_type === 'Lab') cellClass += ' lab';
                        if (m.class_type === 'Tutorial') cellClass += ' tutorial';
                        div.className = cellClass;

                        div.innerHTML = `
                            <div class="subjectCode">${m.subject_code}</div>
                            <div class="subjectName">${m.subject_name}</div>
                            <div class="classType ${m.class_type.toLowerCase()}">${m.class_type}</div>
                            <div class="lecturerName">${m.lecturer}</div>
                            <div class="facilityName">${m.facility}</div>
                            ${m.intake_code ? `<div class="intakeCode">${m.intake_code}</div>` : ''}
                            ${m.status !== 'scheduled' ? `<div class="sessionStatus ${m.status}">${m.status}</div>` : ''}
                        `;
                        td.appendChild(div);
                    });
                } else {
                    td.innerHTML = '<span class="emptySlot">—</span>';
                }

                row.appendChild(td);
            });

            timetableBody.appendChild(row);
        });
    }
});
