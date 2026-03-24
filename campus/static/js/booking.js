document.addEventListener('DOMContentLoaded', function() {
    const tableRows = document.querySelectorAll('tbody tr');

    tableRows.forEach(row => {
        row.addEventListener('click', function(event) {
            if (event.target.closest('a') || event.target.closest('button')) {
                return; 
            }

            tableRows.forEach(r => r.classList.remove('active'));

            this.classList.add('active');
        });
    });

});

document.addEventListener('click', (e) => {
    const tableRows = document.querySelectorAll('tbody tr');
    const clickedRow = e.target.closest('tbody tr');

    if (clickedRow) {
        if (e.target.closest('a') || e.target.closest('button')) return;

        tableRows.forEach(r => r.classList.remove('active'));
        clickedRow.classList.add('active');
    } 
    else {
        tableRows.forEach(r => r.classList.remove('active'));
    }
})