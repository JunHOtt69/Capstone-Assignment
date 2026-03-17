/* ============================================================
   COURSES MANAGEMENT JS
   ============================================================ */
document.addEventListener('DOMContentLoaded', function () {

    // ---- Elements ----
    const courseDropdown    = document.getElementById('courseDropdown');
    const courseOptions     = document.getElementById('courseOptions');
    const semesterDropdown  = document.getElementById('semesterDropdown');
    const semesterOptions   = document.getElementById('semesterOptions');
    const courseInfo        = document.getElementById('courseInfo');
    const courseNameLabel   = document.getElementById('courseNameLabel');
    const semesterLabel    = document.getElementById('semesterLabel');
    const totalSemLabel    = document.getElementById('totalSemLabel');
    const infoBar          = document.getElementById('infoBar');
    const assignedSection  = document.getElementById('assignedSection');
    const addSubjectBtn    = document.getElementById('addSubjectBtn');
    const assignedBody     = document.getElementById('assignedBody');
    const emptyAssigned    = document.getElementById('emptyAssigned');
    const addSubjectModal  = document.getElementById('addSubjectModal');
    const closeAddModal    = document.getElementById('closeAddModal');
    const subjectSearch    = document.getElementById('subjectSearch');
    const availableBody    = document.getElementById('availableBody');
    const emptyAvailable   = document.getElementById('emptyAvailable');

    let selectedCourseId = null;
    let selectedSemester = null;
    let selectedTotalSem = 0;

    // ---- CSRF ----
    function getCSRF() {
        const cookie = document.cookie.split(';').find(c => c.trim().startsWith('csrftoken='));
        return cookie ? cookie.split('=')[1] : '';
    }

    // ---- Helpers ----
    function selectionReady() {
        return selectedCourseId && selectedSemester;
    }

    // ---- Info Bar ----
    function showInfo(msg, type) {
        infoBar.textContent = msg;
        infoBar.className = 'cmInfoBar ' + type;
        infoBar.style.display = 'block';
        setTimeout(function () { infoBar.style.display = 'none'; }, 4000);
    }

    // ---- Component Tags HTML ----
    function componentTagsHTML(components) {
        if (!components || components.length === 0) return '<span class="componentTag">None</span>';
        return components.map(function (c) {
            var cls = c.type.toLowerCase();
            return '<span class="componentTag ' + cls + '">' +
                c.type + ' (' + c.hours_per_class + 'h &times; ' +
                Math.round(c.total_hours / c.hours_per_class) + ')' +
                '</span>';
        }).join(' ');
    }

    // ---- Custom dropdown: course selection ----
    courseDropdown.querySelector('.selectedLabel').addEventListener('click', function () {
        courseDropdown.classList.add('active');
    });

    courseOptions.addEventListener('change', function (e) {
        if (e.target.type !== 'radio') return;
        var chosenText = e.target.nextElementSibling.innerText;
        courseDropdown.querySelector('.selectedLabel label').innerText = chosenText;
        courseDropdown.classList.remove('active');

        selectedCourseId = e.target.value;
        selectedTotalSem = parseInt(e.target.getAttribute('data-total-sem')) || 0;
        selectedSemester = null;

        // Reset and populate semester dropdown
        semesterDropdown.classList.remove('inactive');
        semesterDropdown.querySelector('.selectedLabel label').innerText = 'Choose Semester';
        semesterOptions.innerHTML = '';
        for (var i = 1; i <= selectedTotalSem; i++) {
            semesterOptions.innerHTML +=
                '<div class="option">' +
                '<input type="radio" name="semRadio" id="sem_' + i + '" value="' + i + '">' +
                '<label for="sem_' + i + '">Semester ' + i + '</label>' +
                '</div>';
        }
        semesterDropdown.classList.add('active');

        // Hide content until semester is chosen
        courseInfo.style.display = 'none';
        assignedSection.style.display = 'none';
    });

    // ---- Custom dropdown: semester selection ----
    semesterDropdown.querySelector('.selectedLabel').addEventListener('click', function () {
        if (semesterDropdown.classList.contains('inactive')) return;
        semesterDropdown.classList.add('active');
    });

    semesterOptions.addEventListener('change', function (e) {
        if (e.target.type !== 'radio') return;
        var chosenText = e.target.nextElementSibling.innerText;
        semesterDropdown.querySelector('.selectedLabel label').innerText = chosenText;
        semesterDropdown.classList.remove('active');

        selectedSemester = e.target.value;
        loadAssigned();
    });

    // ---- Load Assigned ----
    function loadAssigned() {
        if (!selectionReady()) {
            courseInfo.style.display = 'none';
            assignedSection.style.display = 'none';
            return;
        }

        fetch('/academic/courses/subjects/?course_id=' + encodeURIComponent(selectedCourseId) + '&semester=' + encodeURIComponent(selectedSemester))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.error) { showInfo(data.error, 'error'); return; }

                courseNameLabel.textContent = data.course_code + ' — ' + data.course_name;
                semesterLabel.textContent = data.semester;
                totalSemLabel.textContent = data.total_semesters;
                courseInfo.style.display = 'flex';
                assignedSection.style.display = 'block';

                assignedBody.innerHTML = '';
                if (data.assigned.length === 0) {
                    emptyAssigned.style.display = 'block';
                } else {
                    emptyAssigned.style.display = 'none';
                    data.assigned.forEach(function (s) {
                        var tr = document.createElement('tr');
                        tr.innerHTML =
                            '<td class="no-col"></td>' +
                            '<td>' + s.subject_code + '</td>' +
                            '<td>' + s.subject_name + '</td>' +
                            '<td><div class="componentTags">' + componentTagsHTML(s.components) + '</div></td>' +
                            '<td class="action-col"><button class="removeBtn" data-csid="' + s.cs_id + '">Remove</button></td>';
                        assignedBody.appendChild(tr);
                    });
                    bindRemoveButtons();
                }
            })
            .catch(function () { showInfo('Failed to load assigned subjects.', 'error'); });
    }

    // ---- Remove ----
    function bindRemoveButtons() {
        assignedBody.querySelectorAll('.removeBtn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var csId = this.getAttribute('data-csid');
                fetch('/academic/courses/remove/', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
                    body: JSON.stringify({ cs_id: csId })
                })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (data.success) {
                        showInfo(data.message, 'success');
                        loadAssigned();
                    } else {
                        showInfo(data.error || 'Failed to remove.', 'error');
                    }
                })
                .catch(function () { showInfo('Network error.', 'error'); });
            });
        });
    }

    // ---- Available subjects ----
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
                    '<td><div class="componentTags">' + componentTagsHTML(s.components) + '</div></td>' +
                    '<td class="action-col"><button class="cmBtn cmBtnAssign" data-sid="' + s.subject_id + '">Assign</button></td>';
                availableBody.appendChild(tr);
            });
            bindAssignButtons();
        }
    }

    var cachedAvailable = [];

    function loadAvailableAndCache() {
        if (!selectionReady()) return;

        fetch('/academic/courses/available/?course_id=' + encodeURIComponent(selectedCourseId) + '&semester=' + encodeURIComponent(selectedSemester))
            .then(function (r) { return r.json(); })
            .then(function (data) {
                if (data.error) { showInfo(data.error, 'error'); return; }
                cachedAvailable = data.available;
                renderAvailable(cachedAvailable);
            })
            .catch(function () { showInfo('Failed to load available subjects.', 'error'); });
    }

    // ---- Assign ----
    function bindAssignButtons() {
        availableBody.querySelectorAll('.cmBtnAssign').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var subjectId = this.getAttribute('data-sid');

                fetch('/academic/courses/assign/', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
                    body: JSON.stringify({ course_id: selectedCourseId, semester: selectedSemester, subject_id: subjectId })
                })
                .then(function (r) { return r.json(); })
                .then(function (data) {
                    if (data.success) {
                        showInfo(data.message, 'success');
                        loadAssigned();
                        loadAvailableAndCache();
                    } else {
                        showInfo(data.error || 'Failed to assign.', 'error');
                    }
                })
                .catch(function () { showInfo('Network error.', 'error'); });
            });
        });
    }

    // ---- Modal Events ----
    addSubjectBtn.addEventListener('click', function () {
        addSubjectModal.style.display = 'flex';
        subjectSearch.value = '';
        loadAvailableAndCache();
    });

    closeAddModal.addEventListener('click', function () {
        addSubjectModal.style.display = 'none';
    });

    addSubjectModal.addEventListener('click', function (e) {
        if (e.target === addSubjectModal) addSubjectModal.style.display = 'none';
    });

    subjectSearch.addEventListener('input', function () {
        renderAvailable(cachedAvailable);
    });
});
