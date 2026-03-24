/* ============================================================
   TIMETABLE MODULE JS
   ============================================================ */
document.addEventListener('DOMContentLoaded', function () {
    const termDropdown = document.getElementById('termDropdown');
    const termOptions  = document.getElementById('termOptions');
    let selectedTermId = null;
    const weekNav = document.getElementById('weekNav');
    const actionBtns = document.getElementById('actionBtns');
    const prevWeekBtn = document.getElementById('prevWeekBtn');
    const nextWeekBtn = document.getElementById('nextWeekBtn');
    const weekLabel = document.getElementById('weekLabel');
    const generateBtn = document.getElementById('generateBtn');
    const deleteWeekBtn = document.getElementById('deleteWeekBtn');
    const savePreferenceBtn = document.getElementById('savePreferenceBtn');
    const replicateBtn = document.getElementById('replicateBtn');
    const missingBtn = document.getElementById('missingBtn');
    const addSkipBtn = document.getElementById('addSkipBtn');
    const timetableGrid = document.getElementById('timetableGrid');
    const timetableBody = document.getElementById('timetableBody');

    const skippedDatesSection = document.getElementById('skippedDatesSection');
    const skippedDatesList = document.getElementById('skippedDatesList');

    // Modals
    const missingModal = document.getElementById('missingModal');
    const closeMissingModal = document.getElementById('closeMissingModal');
    const missingModalBody = document.getElementById('missingModalBody');

    const skipModal = document.getElementById('skipModal');
    const closeSkipModal = document.getElementById('closeSkipModal');
    const confirmSkipBtn = document.getElementById('confirmSkipBtn');
    const skipDateInput = document.getElementById('skipDateInput');
    const skipReasonInput = document.getElementById('skipReasonInput');

    const replicateModal = document.getElementById('replicateModal');
    const closeReplicateModal = document.getElementById('closeReplicateModal');
    const confirmReplicateBtn = document.getElementById('confirmReplicateBtn');
    const replicateWeekSelect = document.getElementById('replicateWeekSelect');

    let currentWeekMonday = null;
    let termStart = null;
    let termEnd = null;
    let teachingCutoff = null;
    let allTimeSlots = [];
    let selectedSemester = null;

    // CSRF
    function getCSRF() {
        const cookie = document.cookie.split(';').find(c => c.trim().startsWith('csrftoken='));
        return cookie ? cookie.split('=')[1] : '';
    }

    // ── Date helpers (pure arithmetic, no Date object timezone issues) ──

    /** Parse 'YYYY-MM-DD' → {y, m, d} */
    function parseParts(s) {
        const p = s.split('-');
        return { y: +p[0], m: +p[1], d: +p[2] };
    }

    /** Days in a given month (1-indexed). Handles leap years. */
    function daysInMonth(y, m) {
        return new Date(y, m, 0).getDate();
    }

    /** Add `n` days to a YYYY-MM-DD string and return YYYY-MM-DD. */
    function addDays(dateStr, n) {
        const p = parseParts(dateStr);
        let y = p.y, m = p.m, d = p.d + n;
        while (d > daysInMonth(y, m)) { d -= daysInMonth(y, m); m++; if (m > 12) { m = 1; y++; } }
        while (d < 1) { m--; if (m < 1) { m = 12; y--; } d += daysInMonth(y, m); }
        return `${y}-${String(m).padStart(2,'0')}-${String(d).padStart(2,'0')}`;
    }

    /** Return the Monday (ISO weekday 1) of the week containing dateStr. */
    function getMondayOfWeek(dateStr) {
        const dt = new Date(dateStr + 'T12:00:00');   // noon avoids DST edge
        const dow = dt.getDay();                       // 0=Sun … 6=Sat
        const offset = dow === 0 ? -6 : 1 - dow;      // shift to Monday
        return addDays(dateStr, offset);
    }

    /** Format 'YYYY-MM-DD' → '28 Jan 2026' style. */
    function formatDate(dateStr) {
        const p = parseParts(dateStr);
        const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        return `${p.d} ${months[p.m - 1]} ${p.y}`;
    }

    /** Return 1-based week number within the term. */
    function getWeekNumber(mondayStr, termStartStr) {
        const m = new Date(mondayStr + 'T12:00:00');
        const s = new Date(getMondayOfWeek(termStartStr) + 'T12:00:00');
        const diff = Math.round((m - s) / (7 * 864e5));
        return diff + 1;
    }

    /** Compare two YYYY-MM-DD strings: <0, 0, >0 */
    function cmpDate(a, b) { return a < b ? -1 : a > b ? 1 : 0; }

    function showInfo(msg, type) {
        showNotif(type, msg);
    }

    /** Get today as YYYY-MM-DD string. */
    function getTodayStr() {
        const now = new Date();
        return `${now.getFullYear()}-${String(now.getMonth()+1).padStart(2,'0')}-${String(now.getDate()).padStart(2,'0')}`;
    }

    /** Check if the displayed week is a future week (after the current week). */
    function isFutureWeek() {
        const todayMonday = getMondayOfWeek(getTodayStr());
        return cmpDate(currentWeekMonday, todayMonday) > 0;
    }

    /** Update week label and disable prev/next when at bounds. */
    function updateWeekNav() {
        if (!currentWeekMonday || !termStart || !termEnd) return;
        const friday = addDays(currentWeekMonday, 4);
        const weekNum = getWeekNumber(currentWeekMonday, termStart);
        weekLabel.textContent = `Week ${weekNum}  ·  ${formatDate(currentWeekMonday)} — ${formatDate(friday)}`;

        const termMonday = getMondayOfWeek(termStart);
        prevWeekBtn.disabled = cmpDate(currentWeekMonday, termMonday) <= 0;

        const lastMonday = getMondayOfWeek(termEnd);
        nextWeekBtn.disabled = cmpDate(currentWeekMonday, lastMonday) >= 0;

        // Disable generate & delete for current or past weeks
        const future = isFutureWeek();
        if (future) {
            generateBtn.disabled = false;
            deleteWeekBtn.disabled = false;
            generateBtn.classList.remove('disabled');
            deleteWeekBtn.classList.remove('disabled');
            generateBtn.title = '';
            deleteWeekBtn.title = '';
        } else {
            generateBtn.disabled = true;
            deleteWeekBtn.disabled = true;
            generateBtn.classList.add('disabled');
            deleteWeekBtn.classList.add('disabled');
            generateBtn.title = 'Cannot generate timetable for current or past weeks';
            deleteWeekBtn.title = 'Cannot delete timetable for current or past weeks';
        }
    }

    // Term selection
    // Term selection (custom dropdown)
    termDropdown.querySelector('.selectedLabel').addEventListener('click', function () {
        termDropdown.classList.add('active');
    });

    termOptions.addEventListener('change', function (e) {
        if (e.target.type !== 'radio') return;
        var chosenText = e.target.nextElementSibling.innerText;
        termDropdown.querySelector('.selectedLabel label').innerText = chosenText;
        termDropdown.classList.remove('active');

        selectedTermId = e.target.value;
        termStart = e.target.getAttribute('data-start');
        termEnd = e.target.getAttribute('data-end');

        // Auto-set semester from the intake's current semester
        selectedSemester = parseInt(e.target.getAttribute('data-current-semester')) || 1;

        currentWeekMonday = getMondayOfWeek(termStart);

        weekNav.style.display = 'flex';
        actionBtns.style.display = 'flex';
        timetableGrid.style.display = 'block';

        updateWeekNav();
        loadTimetable();
    });

    // Week navigation
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

    // Load timetable data
    function loadTimetable() {
        const termId = selectedTermId;
        if (!termId || !currentWeekMonday) return;

        fetch(`/academic/timetable/data/?term_id=${encodeURIComponent(termId)}&week_start=${encodeURIComponent(currentWeekMonday)}&semester=${encodeURIComponent(selectedSemester || '')}`)
            .then(r => r.json())
            .then(data => {
                if (data.error) {
                    showInfo(data.error, 'error');
                    return;
                }

                teachingCutoff = data.teaching_cutoff;
                renderTimetable(data.timetable);
                renderSkippedDates(data.skipped_dates);

                if (data.has_preference) {
                    showInfo('Active preference exists for this intake. Use "Replicate" to apply to other weeks.', 'info');
                }
            })
            .catch(err => showInfo('Failed to load timetable: ' + err, 'error'));
    }

    // Render the grid
    function renderTimetable(sessions) {
        timetableBody.innerHTML = '';

        // Find all unique time slots
        const slotMap = {};
        sessions.forEach(s => {
            const key = s.start_time + '-' + s.end_time;
            if (!slotMap[key]) slotMap[key] = { start: s.start_time, end: s.end_time };
        });

        allTimeSlots = Object.values(slotMap).sort((a, b) => a.start.localeCompare(b.start));

        if (allTimeSlots.length === 0) {
            timetableBody.innerHTML = '<tr><td colspan="6" class="emptySlot">No classes scheduled for this week.</td></tr>';
            return;
        }

        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

        allTimeSlots.forEach(slot => {
            const row = document.createElement('tr');
            const timeCell = document.createElement('td');
            timeCell.textContent = slot.start + ' - ' + slot.end;
            timeCell.style.fontWeight = '600';
            row.appendChild(timeCell);

            days.forEach(day => {
                const td = document.createElement('td');
                const matching = sessions.filter(s => s.day === day && s.start_time === slot.start && s.end_time === slot.end);

                if (matching.length > 1) {
                    td.classList.add('conflict');
                }

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

    // Render skipped dates
    function renderSkippedDates(skippedDates) {
        if (!skippedDates || skippedDates.length === 0) {
            skippedDatesSection.style.display = 'none';
            return;
        }
        skippedDatesSection.style.display = 'block';
        skippedDatesList.innerHTML = '';

        skippedDates.forEach(sd => {
            const li = document.createElement('li');
            const dateStr = typeof sd.date === 'string' ? sd.date : sd.date;
            li.innerHTML = `<span>${formatDate(dateStr)} — ${sd.reason || 'N/A'}</span>
                <button class="skipRemoveBtn" data-date="${dateStr}">&times;</button>`;
            skippedDatesList.appendChild(li);
        });

        // Attach remove handlers
        skippedDatesList.querySelectorAll('.skipRemoveBtn').forEach(btn => {
            btn.addEventListener('click', function () {
                removeSkippedDate(this.dataset.date);
            });
        });
    }

    // Generate timetable
    generateBtn.addEventListener('click', function (e) {
        if (generateBtn.disabled || generateBtn.classList.contains('disabled')) {
            showInfo('Cannot generate timetable for current or past weeks.', 'error');
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
        const termId = selectedTermId;
        if (!termId) return;

        if (!confirm('Generate a timetable for this week? Existing sessions will not be overwritten.')) return;

        generateBtn.disabled = true;
        fetch('/academic/timetable/generate/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ term_id: termId, week_start: currentWeekMonday, semester: selectedSemester })
        })
        .then(r => {
            if (r.status === 401) {
                window.location.href = '/login/';
                throw new Error('Session expired');
            }
            if (!r.ok) {
                return r.json().then(d => { throw new Error(d.error || 'Server error'); });
            }
            return r.json();
        })
        .then(data => {
            generateBtn.disabled = false;
            if (data.error) {
                showInfo(data.error, 'error');
                return;
            }
            showInfo(`Generated ${data.created} session(s). ${data.errors.length ? 'Warnings: ' + data.errors.join('; ') : ''}`, 'success');
            loadTimetable();
        })
        .catch(err => {
            generateBtn.disabled = false;
            showInfo('Error: ' + err, 'error');
        });
    });

    // Delete week timetable
    deleteWeekBtn.addEventListener('click', function (e) {
        if (deleteWeekBtn.disabled || deleteWeekBtn.classList.contains('disabled')) {
            showInfo('Cannot delete timetable for current or past weeks.', 'error');
            e.preventDefault();
            e.stopPropagation();
            return false;
        }
        const termId = selectedTermId;
        if (!termId) return;

        if (!confirm(`Delete scheduled sessions for Semester ${selectedSemester} this week? This cannot be undone.`)) return;

        deleteWeekBtn.disabled = true;
        fetch('/academic/timetable/delete-week/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ term_id: termId, week_start: currentWeekMonday, semester: selectedSemester })
        })
        .then(r => {
            if (r.status === 401) {
                window.location.href = '/login/';
                throw new Error('Session expired');
            }
            if (!r.ok) {
                return r.json().then(d => { throw new Error(d.error || 'Server error'); });
            }
            return r.json();
        })
        .then(data => {
            deleteWeekBtn.disabled = false;
            if (data.error) {
                showInfo(data.error, 'error');
                return;
            }
            showInfo(`Deleted ${data.deleted} session(s).`, 'success');
            loadTimetable();
        })
        .catch(err => {
            deleteWeekBtn.disabled = false;
            showInfo('Error: ' + err, 'error');
        });
    });

    // Save preference
    savePreferenceBtn.addEventListener('click', function () {
        const termId = selectedTermId;
        if (!termId) return;

        if (!confirm('Save the current week as the scheduling preference?')) return;

        fetch('/academic/timetable/save-preference/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ term_id: termId, week_start: currentWeekMonday, semester: selectedSemester })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showInfo(data.error, 'error'); return; }
            showInfo(data.message, 'success');
        })
        .catch(err => showInfo('Error: ' + err, 'error'));
    });

    // Replicate modal — populate week dropdown and handle submit
    replicateBtn.addEventListener('click', () => {
        if (!termStart || !termEnd) { showInfo('Please select a term first.', 'warning'); return; }
        // Build week list
        replicateWeekSelect.innerHTML = '';
        const firstMonday = getMondayOfWeek(termStart);
        const lastMonday  = getMondayOfWeek(termEnd);
        let mon = firstMonday;
        let wk = 1;
        while (cmpDate(mon, lastMonday) <= 0) {
            const fri = addDays(mon, 4);
            const opt = document.createElement('option');
            opt.value = mon;
            opt.textContent = `Week ${wk}  (${formatDate(mon)} — ${formatDate(fri)})`;
            replicateWeekSelect.appendChild(opt);
            mon = addDays(mon, 7);
            wk++;
        }
        replicateModal.style.display = 'flex';
    });
    closeReplicateModal.addEventListener('click', () => { replicateModal.style.display = 'none'; });

    confirmReplicateBtn.addEventListener('click', function () {
        const termId = selectedTermId;
        const selectedWeeks = Array.from(replicateWeekSelect.selectedOptions).map(o => o.value);
        if (!termId || selectedWeeks.length === 0) { showInfo('Please select at least one target week.', 'warning'); return; }

        fetch('/academic/timetable/replicate/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ term_id: termId, target_weeks: selectedWeeks, semester: selectedSemester })
        })
        .then(r => r.json())
        .then(data => {
            replicateModal.style.display = 'none';
            if (data.error) { showInfo(data.error, 'error'); return; }
            let msg = `Replicated ${data.created} session(s) across ${data.weeks_processed} week(s).`;
            if (data.skipped_classes && data.skipped_classes.length > 0) {
                msg += ` ${data.skipped_classes.length} class(es) skipped.`;
            }
            if (data.weeks_with_errors && data.weeks_with_errors.length > 0) {
                msg += ` ${data.weeks_with_errors.length} week(s) had issues.`;
            }
            showInfo(msg, 'success');
            updateWeekNav();
            loadTimetable();
        })
        .catch(err => showInfo('Error: ' + err, 'error'));
    });

    // Missing classes modal
    missingBtn.addEventListener('click', function () {
        const termId = selectedTermId;
        if (!termId) return;

        missingModalBody.innerHTML = '<p>Loading...</p>';
        missingModal.style.display = 'flex';

        fetch(`/academic/timetable/missing/?term_id=${encodeURIComponent(termId)}`)
            .then(r => r.json())
            .then(data => {
                if (!data.missing_classes || data.missing_classes.length === 0) {
                    missingModalBody.innerHTML = '<p>No missing or cancelled classes.</p>';
                    return;
                }
                missingModalBody.innerHTML = '';
                data.missing_classes.forEach(mc => {
                    const div = document.createElement('div');
                    div.className = 'missingItem';
                    div.innerHTML = `
                        <div class="missingInfo"><strong>${mc.subject_code}</strong> — ${mc.subject_name}</div>
                        <div class="missingInfo">Date: ${formatDate(mc.date)} | ${mc.start_time} - ${mc.end_time}</div>
                        <div class="missingInfo">Lecturer: ${mc.lecturer}</div>
                        <button class="rearrangeBtn" data-id="${mc.id}">Rearrange</button>
                    `;
                    missingModalBody.appendChild(div);
                });

                // Attach rearrange handlers
                missingModalBody.querySelectorAll('.rearrangeBtn').forEach(btn => {
                    btn.addEventListener('click', function () {
                        rearrangeClass(this.dataset.id);
                    });
                });
            })
            .catch(err => {
                missingModalBody.innerHTML = '<p>Error loading data.</p>';
            });
    });
    closeMissingModal.addEventListener('click', () => { missingModal.style.display = 'none'; });

    // Add skip date modal
    addSkipBtn.addEventListener('click', () => { skipModal.style.display = 'flex'; });
    closeSkipModal.addEventListener('click', () => { skipModal.style.display = 'none'; });

    confirmSkipBtn.addEventListener('click', function () {
        const termId = selectedTermId;
        const skipDate = skipDateInput.value;
        const reason = skipReasonInput.value || 'Public Holiday';

        if (!termId || !skipDate) { showInfo('Please fill in the date.', 'warning'); return; }

        fetch('/academic/timetable/skip-date/add/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ term_id: termId, date: skipDate, reason: reason })
        })
        .then(r => r.json())
        .then(data => {
            skipModal.style.display = 'none';
            skipDateInput.value = '';
            skipReasonInput.value = '';
            if (data.error) { showInfo(data.error, 'error'); return; }
            showInfo(data.message, 'success');
            loadTimetable();
        })
        .catch(err => showInfo('Error: ' + err, 'error'));
    });

    // Remove skipped date
    function removeSkippedDate(dateStr) {
        const termId = selectedTermId;
        if (!confirm('Remove this skipped date?')) return;

        fetch('/academic/timetable/skip-date/remove/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ term_id: termId, date: dateStr })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showInfo(data.error, 'error'); return; }
            showInfo(data.message, 'success');
            loadTimetable();
        })
        .catch(err => showInfo('Error: ' + err, 'error'));
    }

    // Rearrange a cancelled class
    function rearrangeClass(classSessionId) {
        if (!confirm('Attempt to rearrange this class to an available slot?')) return;

        fetch('/academic/timetable/rearrange/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ class_session_id: classSessionId })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showInfo(data.error, 'error'); return; }
            showInfo(data.message, 'success');
            missingModal.style.display = 'none';
            loadTimetable();
        })
        .catch(err => showInfo('Error: ' + err, 'error'));
    }

    // Close modals on backdrop click
    [missingModal, skipModal, replicateModal].forEach(modal => {
        modal.addEventListener('click', function (e) {
            if (e.target === modal) modal.style.display = 'none';
        });
    });
});
