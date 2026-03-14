document.addEventListener('DOMContentLoaded', async() => {
    document.getElementById('sortSelect').addEventListener('change', function() {
        const sortBy = this.value;
        const container = document.getElementById('ticket-table-container');

        container.style.opacity = '0.5';

        fetch(`/support/tickets/partial/?sort=${sortBy}`, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(response => response.json())
        .then(data => {
            container.innerHTML = data.html;
            container.style.opacity = '1';
        })
        .catch(error => console.error('Error:', error));
    });
})