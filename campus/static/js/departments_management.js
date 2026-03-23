/* ============================================================
   DEPARTMENTS MANAGEMENT JS
   ============================================================ */
document.addEventListener('DOMContentLoaded', function () {

    // ---- Elements ----
    const deptDropdown     = document.getElementById('deptDropdown');
    const deptOptions      = document.getElementById('deptOptions');
    const deptInfo         = document.getElementById('deptInfo');
    const deptNameLabel    = document.getElementById('deptNameLabel');

    const lecturersSection = document.getElementById('lecturersSection');
    const lecturersBody    = document.getElementById('lecturersBody');
    const emptyLecturers   = document.getElementById('emptyLecturers');
    const assignSubjectModal = document.getElementById('assignSubjectModal');
    const closeAssignModal = document.getElementById('closeAssignModal');
    const modalLecturerName = document.getElementById('modalLecturerName');
    const subjectSearch    = document.getElementById('subjectSearch');
    const availableBody    = document.getElementById('availableBody');
    const emptyAvailable   = document.getElementById('emptyAvailable');

    let selectedDeptId = null;
    let selectedUserId = null;
    let cachedAvailable = [];

    // ---- CSRF ----
    function getCSRF() {
        const cookie = document.cookie.split(';').find(function (c) { return c.trim().startsWith('csrftoken='); });
        return cookie ? cookie.split('=')[1] : '';
    }

    // ---- Info Bar ----
    function showInfo(msg, type) {
        showNotif(type, msg);
    }

    // ---- Custom dropdown: department selection ----
    deptDropdown.querySelector('.selectedLabel').addEventListener('click', function () {
        deptDropdown.classList.add('active');
    });

    deptOptions.addEventListener('change', function (e) {
        if (e.target.type !== 'radio') return;
        var chosenText = e.target.nextElementSibling.innerText;
        deptDropdown.querySelector('.selectedLabel label').innerText = chosenText;
        deptDropdown.classList.remove('active');

        selectedDeptId = e.target.value;
        loadLecturers();
    });

    // ---- Load Lecturers ----
    function loadLecturers() {
        if (!selectedDeptId) return;

        fetch('/academic/departments/lecturers/?dept_id=' + encodeURIComponent(selectedDeptId))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.error) { showInfo(data.error, 'error'); return; }

                deptNameLabel.textContent = data.dept_code + ' — ' + data.dept_name;
                deptInfo.style.display = 'flex';
                lecturersSection.style.display = 'block';

                lecturersBody.innerHTML = '';
                if (data.lecturers.length === 0) {
                    emptyLecturers.style.display = 'block';
                } else {
                    emptyLecturers.style.display = 'none';
                    data.lecturers.forEach(function (lec) {
                        var tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td class="no-col"></td>' +
                            '<td>' + lec.lc_id + '</td>' +
                            '<td>' + lec.name + '</td>' +
                            '<td>' + lec.max_hours + '</td>' +
                            '<td><div class="subjectTagsWrapper">' + subjectTagsHTML(lec.subjects) + '</div></td>' +
                            '<td class="action-col"><button class="cmBtn cmBtnAssign assignSubjectBtn" data-uid="' + lec.user_id + '" data-name="' + lec.name + '">+ Add</button></td>';
                        lecturersBody.appendChild(tr);
                    });
                    bindAssignButtons();
                }
            })
            .catch(function () { showInfo('Failed to load lecturers.', 'error'); });
    }

    // ---- Subject Tags HTML ----
    function subjectTagsHTML(subjects) {
        if (!subjects || subjects.length === 0) {
            return '<span class="componentTag">None assigned</span>';
        }
        return subjects.map(function (s) {
            var leadClass = s.is_lead ? ' lead' : '';
            return '<span class="componentTag lecture' + leadClass + '">' +
                s.subject_code +
                (s.is_lead ? ' ★' : '') +
                '<button class="tagRemove" data-lsid="' + s.ls_id + '" title="Remove">&times;</button>' +
                '</span>';
        }).join(' ');
    }

    // ---- Bind assign buttons on lecturer rows ----
    function bindAssignButtons() {
        lecturersBody.querySelectorAll('.assignSubjectBtn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                selectedUserId = this.getAttribute('data-uid');
                modalLecturerName.textContent = this.getAttribute('data-name');
                assignSubjectModal.style.display = 'flex';
                subjectSearch.value = '';
                loadAvailableSubjects();
            });
        });
    }

    // ---- Remove subject tag ----
    lecturersBody.addEventListener('click', function (e) {
        var btn = e.target.closest('.tagRemove');
        if (!btn) return;

        var lsId = btn.getAttribute('data-lsid');
        if (!confirm('Remove this subject qualification?')) return;

        fetch('/academic/departments/subjects/remove/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ ls_id: parseInt(lsId) })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (data.success) {
                showInfo(data.message, 'success');
                loadLecturers();
            } else {
                showInfo(data.error || 'Failed to remove.', 'error');
            }
        })
        .catch(function () { showInfo('Network error.', 'error'); });
    });

    // ---- Load available subjects for modal ----
    function loadAvailableSubjects() {
        if (!selectedUserId) return;

        fetch('/academic/departments/subjects/available/?user_id=' + encodeURIComponent(selectedUserId))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.error) { showInfo(data.error, 'error'); return; }
                cachedAvailable = data.available;
                renderAvailable(cachedAvailable);
            })
            .catch(function () { showInfo('Failed to load subjects.', 'error'); });
    }

    // ---- Render available subjects ----
    function renderAvailable(list) {
        availableBody.innerHTML = '';
        var query = (subjectSearch.value || '').toLowerCase();
        var filtered = list.filter(function (s) {
            return s.subject_code.toLowerCase().indexOf(query) !== -1 ||
                   s.subject_name.toLowerCase().indexOf(query) !== -1;
        });

        if (filtered.length === 0) {
            emptyAvailable.style.display = 'block';
        } else {
            emptyAvailable.style.display = 'none';
            filtered.forEach(function (s) {
                var tr = document.createElement('tr');
                tr.innerHTML =
                    '<td class="no-col"></td>' +
                    '<td>' + s.subject_code + '</td>' +
                    '<td>' + s.subject_name + '</td>' +
                    '<td class="action-col"><button class="cmBtn cmBtnAssign" data-sid="' + s.subject_id + '">Assign</button></td>';
                availableBody.appendChild(tr);
            });
            bindModalAssignButtons();
        }
    }

    // ---- Bind assign buttons in modal ----
    function bindModalAssignButtons() {
        availableBody.querySelectorAll('.cmBtnAssign').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var subjectId = this.getAttribute('data-sid');

                fetch('/academic/departments/subjects/assign/', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
                    body: JSON.stringify({ user_id: parseInt(selectedUserId), subject_id: parseInt(subjectId) })
                })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (data.success) {
                        showInfo(data.message, 'success');
                        loadLecturers();
                        loadAvailableSubjects();
                    } else {
                        showInfo(data.error || 'Failed to assign.', 'error');
                    }
                })
                .catch(function () { showInfo('Network error.', 'error'); });
            });
        });
    }

    // ---- Modal Events ----
    closeAssignModal.addEventListener('click', function () {
        assignSubjectModal.style.display = 'none';
    });

    assignSubjectModal.addEventListener('click', function (e) {
        if (e.target === assignSubjectModal) assignSubjectModal.style.display = 'none';
    });

    subjectSearch.addEventListener('input', function () {
        renderAvailable(cachedAvailable);
    });
});
