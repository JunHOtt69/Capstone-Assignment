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

    const loading = document.querySelector('.loading');
    const bookingForm = document.querySelector('form'); // Targets the booking form

    if (bookingForm) {
        bookingForm.addEventListener("submit", function (e) {
            if (bookingForm.checkValidity()) {
                loading.classList.add("active");

                const submitBtn = bookingForm.querySelector('.submitbookBtn');
                if (submitBtn) {
                    submitBtn.style.pointerEvents = "none";
                    submitBtn.style.opacity = "0.5";
                }
            } else {
                return false;
            }
        });
    }

    const simpleLinks = document.querySelectorAll(".requestBooking, #confirmCancelBtn, #approveBtn, #rejectBtn");
    simpleLinks.forEach(link => {
        link.addEventListener("click", function () {
            loading.classList.add("active");
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