document.addEventListener('DOMContentLoaded', function () {
    var subjectSearch   = document.getElementById('subjectSearch');
    var subjectsBody    = document.getElementById('subjectsBody');
    var addSubjectBtn   = document.getElementById('addSubjectBtn');
    var subjectModal    = document.getElementById('subjectModal');
    var modalTitle      = document.getElementById('modalTitle');
    var closeModal      = document.getElementById('closeModal');
    var editSubjectId   = document.getElementById('editSubjectId');
    var subjectCode     = document.getElementById('subjectCode');
    var subjectName     = document.getElementById('subjectName');
    var componentsList  = document.getElementById('componentsList');
    var addComponentBtn = document.getElementById('addComponentBtn');
    var saveSubjectBtn  = document.getElementById('saveSubjectBtn');
    var cancelBtn       = document.getElementById('cancelBtn');
    var deleteModal     = document.getElementById('deleteModal');
    var deleteSubjectName = document.getElementById('deleteSubjectName');
    var deleteSubjectId = document.getElementById('deleteSubjectId');
    var confirmDeleteBtn = document.getElementById('confirmDeleteBtn');
    var cancelDeleteBtn = document.getElementById('cancelDeleteBtn');
    var closeDeleteModal = document.getElementById('closeDeleteModal');

    var componentTypes = ['Lecture', 'Tutorial', 'Lab', 'Practical', 'Fieldwork'];

    function getCSRF() {
        var cookie = document.cookie.split(';').find(function (c) {
            return c.trim().startsWith('csrftoken=');
        });
        return cookie ? cookie.split('=')[1] : '';
    }

    function showInfo(msg, type) {
        showNotif(type, msg);
    }

    subjectSearch.addEventListener('input', function () {
        var query = this.value.toLowerCase();
        var rows = subjectsBody.querySelectorAll('tr[data-id]');
        rows.forEach(function (row) {
            var code = row.children[1].textContent.toLowerCase();
            var name = row.children[2].textContent.toLowerCase();
            row.style.display = (code.indexOf(query) !== -1 || name.indexOf(query) !== -1) ? '' : 'none';
        });
    });

    function addComponentRow(type, hours, totalHours, componentId) {
        var row = document.createElement('div');
        row.className = 'componentRow';
        if (componentId) row.setAttribute('data-comp-id', componentId);

        var select = document.createElement('select');
        select.className = 'compType';
        componentTypes.forEach(function (t) {
            var opt = document.createElement('option');
            opt.value = t;
            opt.textContent = t;
            if (t === type) opt.selected = true;
            select.appendChild(opt);
        });

        var hoursInput = document.createElement('input');
        hoursInput.type = 'number';
        hoursInput.className = 'compHours';
        hoursInput.min = '1';
        hoursInput.max = '8';
        hoursInput.value = hours || 2;
        hoursInput.placeholder = 'Hrs/Class';
        hoursInput.title = 'Hours per class';

        var totalInput = document.createElement('input');
        totalInput.type = 'number';
        totalInput.className = 'compTotal';
        totalInput.min = '0';
        totalInput.value = totalHours || 0;
        totalInput.placeholder = 'Total Hrs';
        totalInput.title = 'Total required hours';

        var removeBtn = document.createElement('button');
        removeBtn.type = 'button';
        removeBtn.className = 'removeComponentBtn';
        removeBtn.innerHTML = '&times;';
        removeBtn.addEventListener('click', function () {
            row.remove();
        });

        row.appendChild(select);
        row.appendChild(hoursInput);
        row.appendChild(totalInput);
        row.appendChild(removeBtn);
        componentsList.appendChild(row);
    }

    addSubjectBtn.addEventListener('click', function () {
        modalTitle.textContent = 'Create Subject';
        editSubjectId.value = '';
        subjectCode.value = '';
        subjectName.value = '';
        componentsList.innerHTML = '';
        addComponentRow('Lecture', 2, 0);
        subjectModal.style.display = 'flex';
    });

    addComponentBtn.addEventListener('click', function () {
        addComponentRow('Lecture', 2, 0);
    });

    closeModal.addEventListener('click', function () { subjectModal.style.display = 'none'; });
    cancelBtn.addEventListener('click', function () { subjectModal.style.display = 'none'; });
    subjectModal.addEventListener('click', function (e) {
        if (e.target === subjectModal) subjectModal.style.display = 'none';
    });
    closeDeleteModal.addEventListener('click', function () { deleteModal.style.display = 'none'; });
    cancelDeleteBtn.addEventListener('click', function () { deleteModal.style.display = 'none'; });
    deleteModal.addEventListener('click', function (e) {
        if (e.target === deleteModal) deleteModal.style.display = 'none';
    });

    saveSubjectBtn.addEventListener('click', function () {
        var code = subjectCode.value.trim();
        var name = subjectName.value.trim();
        if (!code || !name) {
            showInfo('Subject code and name are required.', 'error');
            return;
        }

        var components = [];
        var compRows = componentsList.querySelectorAll('.componentRow');
        compRows.forEach(function (row) {
            var comp = {
                class_type: row.querySelector('.compType').value,
                hours_per_class: parseInt(row.querySelector('.compHours').value) || 2,
                total_required_hours: parseInt(row.querySelector('.compTotal').value) || 0
            };
            var compId = row.getAttribute('data-comp-id');
            if (compId) comp.component_id = parseInt(compId);
            components.push(comp);
        });

        var subjectId = editSubjectId.value;
        var url = subjectId ? '/academic/subjects/update/' : '/academic/subjects/create/';

        var payload = {
            subject_code: code,
            subject_name: name,
            components: components
        };
        if (subjectId) payload.subject_id = subjectId;

        fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify(payload)
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (data.success) {
                showInfo(data.message, 'success');
                subjectModal.style.display = 'none';
                location.reload();
            } else {
                showInfo(data.error || 'Failed to save subject.', 'error');
            }
        })
        .catch(function () { showInfo('Network error.', 'error'); });
    });

    function bindEditButtons() {
        subjectsBody.querySelectorAll('.editBtn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var sid = this.getAttribute('data-id');

                fetch('/academic/subjects/detail/?subject_id=' + encodeURIComponent(sid))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.error) { showInfo(data.error, 'error'); return; }
                        modalTitle.textContent = 'Edit Subject';
                        editSubjectId.value = data.subject_id;
                        subjectCode.value = data.subject_code;
                        subjectName.value = data.subject_name;
                        componentsList.innerHTML = '';
                        if (data.components.length === 0) {
                            addComponentRow('Lecture', 2, 0, null);
                        } else {
                            data.components.forEach(function (c) {
                                addComponentRow(c.class_type, c.hours_per_class, c.total_required_hours, c.component_id);
                            });
                        }
                        subjectModal.style.display = 'flex';
                    })
                    .catch(function () { showInfo('Failed to load subject details.', 'error'); });
            });
        });
    }

    function bindDeleteButtons() {
        subjectsBody.querySelectorAll('.removeBtn').forEach(function (btn) {
            btn.addEventListener('click', function () {
                var sid = this.getAttribute('data-id');
                fetch('/academic/subjects/check-usage/?subject_id=' + encodeURIComponent(sid))
                    .then(function (r) { return r.json(); })
                    .then(function (data) {
                        if (data.error) { showInfo(data.error, 'error'); return; }
                        deleteSubjectId.value = sid;
                        deleteSubjectName.textContent = data.subject_code + ' — ' + data.subject_name;

                        var warningEl = document.getElementById('deleteWarningText');
                        if (data.timetable_sessions > 0) {
                            warningEl.innerHTML = '<strong>Warning:</strong> This subject has <strong>' +
                                data.timetable_sessions + '</strong> scheduled timetable session(s). ' +
                                'Deleting it will remove all those sessions from the timetable.';
                            warningEl.style.display = 'block';
                        } else {
                            warningEl.innerHTML = 'This will also remove all associated components, course assignments, and lecturer assignments.';
                            warningEl.style.display = 'block';
                        }

                        deleteModal.style.display = 'flex';
                    })
                    .catch(function () { showInfo('Failed to check subject usage.', 'error'); });
            });
        });
    }

    confirmDeleteBtn.addEventListener('click', function () {
        var sid = deleteSubjectId.value;
        fetch('/academic/subjects/delete/', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-CSRFToken': getCSRF() },
            body: JSON.stringify({ subject_id: sid })
        })
        .then(function (r) { return r.json(); })
        .then(function (data) {
            if (data.success) {
                showInfo(data.message, 'success');
                deleteModal.style.display = 'none';
                location.reload();
            } else {
                showInfo(data.error || 'Failed to delete.', 'error');
            }
        })
        .catch(function () { showInfo('Network error.', 'error'); });
    });

    bindEditButtons();
    bindDeleteButtons();
});
