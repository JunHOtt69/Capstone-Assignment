document.addEventListener('DOMContentLoaded', function () {
    const termSelect = document.getElementById('termSelect');
    const weekPicker = document.getElementById('weekPicker');
    const btnLoad = document.getElementById('btnLoadWeek');
    const btnGenerate = document.getElementById('btnGenerate');
    const btnSavePref = document.getElementById('btnSavePref');
    const btnReplicate = document.getElementById('btnReplicate');
    const btnAddSkip = document.getElementById('btnAddSkip');
    const timetableGrid = document.getElementById('timetableGrid');
    const weekInfoBar = document.getElementById('weekInfoBar');
    const missingSection = document.getElementById('missingSection');

    let currentTermId = null;
    let currentWeekStart = null;
    let teachingCutoff = null;

    function getCookie(name) {
        const cookies = document.cookie.split(';');
        for (let c of cookies) {
            c = c.trim();
            if (c.startsWith(name + '=')) return decodeURIComponent(c.substring(name.length + 1));
        }
        return null;
    }

    function showToast(msg, type) {
        const toast = document.getElementById('timetableToast');
        toast.textContent = msg;
        toast.className = 'timetableToast ' + type;
        toast.style.display = 'block';
        setTimeout(() => { toast.style.display = 'none'; }, 4000);
    }

    function getMonday(dateStr) {
        const d = new Date(dateStr);
        const day = d.getDay();
        const diff = d.getDate() - day + (day === 0 ? -6 : 1);
        return new Date(d.setDate(diff));
    }

    function formatDate(dateStr) {
        const d = new Date(dateStr);
        return d.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' });
    }

    function toISODate(d) {
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    function updateButtonStates() {
        const hasTerm = !!currentTermId;
        const hasWeek = !!currentWeekStart;
        btnLoad.disabled = !(hasTerm && weekPicker.value);
        btnGenerate.disabled = !(hasTerm && hasWeek);
        btnSavePref.disabled = !(hasTerm && hasWeek);
        btnReplicate.disabled = !hasTerm;
        btnAddSkip.disabled = !hasTerm;
    }

    termSelect.addEventListener('change', function () {
        currentTermId = this.value || null;
        if (currentTermId) {
            const selected = this.options[this.selectedIndex];
            const startDate = selected.dataset.start;
            if (startDate) {
                const monday = getMonday(startDate);
                weekPicker.value = toISODate(monday);
            }
        }
        updateButtonStates();
    });

    weekPicker.addEventListener('change', function () {
        updateButtonStates();
    });

    // Load week
    btnLoad.addEventListener('click', function () {
        if (!currentTermId || !weekPicker.value) return;
        const monday = getMonday(weekPicker.value);
        currentWeekStart = toISODate(monday);
        weekPicker.value = currentWeekStart;
        loadTimetable();
    });

    function loadTimetable() {
        const url = `/academic/timetable/data/?term_id=${currentTermId}&week_start=${currentWeekStart}`;
        fetch(url)
            .then(r => r.json())
            .then(data => {
                if (data.error) {
                    showToast(data.error, 'error');
                    return;
                }
                teachingCutoff = data.teaching_cutoff;
                renderWeekInfo(data);
                renderGrid(data.timetable);
                renderSkippedDates(data.skipped_dates);
                loadMissingClasses();
                updateButtonStates();
            })
            .catch(err => showToast('Failed to load timetable.', 'error'));
    }

    function renderWeekInfo(data) {
        weekInfoBar.style.display = 'flex';
        const friday = new Date(data.week_start);
        friday.setDate(friday.getDate() + 4);
        document.getElementById('weekLabel').textContent =
            'Week: ' + formatDate(data.week_start) + ' — ' + formatDate(toISODate(friday));
        document.getElementById('termInfo').textContent =
            'Term: ' + formatDate(data.term_start) + ' to ' + formatDate(data.term_end);
        document.getElementById('cutoffInfo').textContent =
            'Teaching until: ' + formatDate(data.teaching_cutoff);
    }

    function renderGrid(timetable) {
        if (!timetable || timetable.length === 0) {
            timetableGrid.innerHTML = '<p class="placeholder">No classes scheduled for this week. Click <b>Generate Timetable</b> to create one.</p>';
            return;
        }

        // Group by day
        const dayOrder = ['MON', 'TUE', 'WED', 'THU', 'FRI'];
        const dayNames = { MON: 'Monday', TUE: 'Tuesday', WED: 'Wednesday', THU: 'Thursday', FRI: 'Friday' };
        const grouped = {};
        dayOrder.forEach(d => grouped[d] = []);
        timetable.forEach(cls => {
            if (grouped[cls.day]) grouped[cls.day].push(cls);
        });

        let html = '<table class="timetableTable">';
        html += '<thead><tr><th>Time</th><th>Subject</th><th>Type</th><th>Lecturer</th><th>Facility</th><th>Status</th></tr></thead>';
        html += '<tbody>';

        dayOrder.forEach(day => {
            const classes = grouped[day];
            html += `<tr class="dayHeader"><td colspan="6">${dayNames[day]}</td></tr>`;
            if (classes.length === 0) {
                html += '<tr><td colspan="6" style="color:#aaa; font-style:italic; padding-left:1.5vw;">No classes</td></tr>';
            } else {
                classes.forEach(cls => {
                    const typeClass = cls.class_type.toLowerCase();
                    html += '<tr>';
                    html += `<td>${cls.start_time} — ${cls.end_time}</td>`;
                    html += `<td><strong>${cls.subject_code}</strong><br>${cls.subject_name}</td>`;
                    html += `<td><span class="classTypeTag ${typeClass}">${cls.class_type}</span></td>`;
                    html += `<td>${cls.lecturer}</td>`;
                    html += `<td>${cls.facility}</td>`;
                    html += `<td><span class="statusBadge ${cls.status}">${cls.status}</span></td>`;
                    html += '</tr>';
                });
            }
        });

        html += '</tbody></table>';
        timetableGrid.innerHTML = html;
    }

    function renderSkippedDates(skippedDates) {
        const container = document.getElementById('skippedDatesList');
        if (!skippedDates || skippedDates.length === 0) {
            container.innerHTML = '<span class="emptyState">No skipped dates set.</span>';
            return;
        }
        let html = '';
        skippedDates.forEach(sd => {
            html += `<span class="skippedDateChip">
                ${formatDate(sd.date)} — ${sd.reason}
                <span class="removeChip" data-date="${sd.date}" title="Remove">&times;</span>
            </span>`;
        });
        container.innerHTML = html;

        container.querySelectorAll('.removeChip').forEach(btn => {
            btn.addEventListener('click', function () {
                removeSkippedDate(this.dataset.date);
            });
        });
    }

    // Generate timetable
    btnGenerate.addEventListener('click', function () {
        if (!currentTermId || !currentWeekStart) return;
        if (!confirm('Generate a full timetable for this intake for the selected week? This will schedule all subjects.')) return;

        fetch('/academic/timetable/generate/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({ term_id: currentTermId, week_start: currentWeekStart })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) {
                showToast(data.error, 'error');
                return;
            }
            showToast(`Timetable generated: ${data.created} class(es) scheduled.`, 'success');
            if (data.errors && data.errors.length > 0) {
                showToast('Warnings: ' + data.errors.join('; '), 'info');
            }
            loadTimetable();
        })
        .catch(() => showToast('Failed to generate timetable.', 'error'));
    });

    // Save preference
    btnSavePref.addEventListener('click', function () {
        if (!currentTermId || !currentWeekStart) return;
        if (!confirm('Save the current weekly arrangement as the active preference? This will replace any existing preference.')) return;

        fetch('/academic/timetable/save-preference/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({ term_id: currentTermId, week_start: currentWeekStart })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast(data.error, 'error'); return; }
            showToast(data.message, 'success');
        })
        .catch(() => showToast('Failed to save preference.', 'error'));
    });

    // Replicate preference
    btnReplicate.addEventListener('click', function () {
        if (!currentTermId) return;
        const targetWeek = prompt('Enter the Monday date of the target week (YYYY-MM-DD):');
        if (!targetWeek) return;

        // Validate format
        if (!/^\d{4}-\d{2}-\d{2}$/.test(targetWeek)) {
            showToast('Please enter a valid date in YYYY-MM-DD format.', 'error');
            return;
        }

        fetch('/academic/timetable/replicate/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({ term_id: currentTermId, target_week: targetWeek })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast(data.error, 'error'); return; }
            let msg = `Replicated: ${data.created} class(es) created.`;
            if (data.skipped_classes && data.skipped_classes.length > 0) {
                msg += ` ${data.skipped_classes.length} class(es) skipped.`;
            }
            showToast(msg, 'success');

            // Offer to load the target week
            weekPicker.value = targetWeek;
            currentWeekStart = targetWeek;
            loadTimetable();
        })
        .catch(() => showToast('Failed to replicate preference.', 'error'));
    });

    // Add skipped date
    btnAddSkip.addEventListener('click', function () {
        const skipDate = document.getElementById('skipDateInput').value;
        const skipReason = document.getElementById('skipReasonInput').value || 'Public Holiday';
        if (!skipDate || !currentTermId) return;

        fetch('/academic/timetable/skip-date/add/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({ term_id: currentTermId, date: skipDate, reason: skipReason })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast(data.error, 'error'); return; }
            showToast(data.message, 'success');
            document.getElementById('skipDateInput').value = '';
            if (currentWeekStart) loadTimetable();
        })
        .catch(() => showToast('Failed to add skipped date.', 'error'));
    });

    function removeSkippedDate(dateStr) {
        if (!confirm('Remove this skipped date?')) return;
        fetch('/academic/timetable/skip-date/remove/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({ term_id: currentTermId, date: dateStr })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast(data.error, 'error'); return; }
            showToast(data.message, 'success');
            if (currentWeekStart) loadTimetable();
        })
        .catch(() => showToast('Failed to remove skipped date.', 'error'));
    }

    // Missing classes
    function loadMissingClasses() {
        if (!currentTermId) return;
        fetch(`/academic/timetable/missing/?term_id=${currentTermId}`)
            .then(r => r.json())
            .then(data => {
                const list = data.missing_classes || [];
                if (list.length === 0) {
                    missingSection.style.display = 'none';
                    return;
                }
                missingSection.style.display = 'block';
                let html = '';
                list.forEach(mc => {
                    html += `<div class="missingCard">
                        <div class="missingInfo">
                            <span><strong>Subject</strong>${mc.subject_code}</span>
                            <span><strong>Lecturer</strong>${mc.lecturer}</span>
                            <span><strong>Original Date</strong>${formatDate(mc.date)}</span>
                            <span><strong>Time</strong>${mc.start_time} — ${mc.end_time}</span>
                        </div>
                        <button class="btn btnWarning btnSmall" onclick="rearrangeClass(${mc.id})">Re-arrange</button>
                    </div>`;
                });
                document.getElementById('missingClassesList').innerHTML = html;
            })
            .catch(() => {});
    }

    // Expose rearrange globally
    window.rearrangeClass = function (classSessionId) {
        if (!confirm('Rearrange this class to the next available slot?')) return;
        fetch('/academic/timetable/rearrange/', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRFToken': getCookie('csrftoken')
            },
            body: JSON.stringify({ class_session_id: classSessionId })
        })
        .then(r => r.json())
        .then(data => {
            if (data.error) { showToast(data.error, 'error'); return; }
            showToast(data.message, 'success');
            if (currentWeekStart) loadTimetable();
        })
        .catch(() => showToast('Failed to rearrange class.', 'error'));
    };
});
