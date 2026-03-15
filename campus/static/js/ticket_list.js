document.addEventListener('DOMContentLoaded', async() => {
    const tableState = {
        't': { sort: '-created_at', categories: [], statuses: [], container: 'ticket-table-container' },
        'my': { sort: '-created_at', categories: [], statuses: [], container: 'my-ticket-table-container' }
    };

    document.addEventListener('click', (event) => {
        const cbxContainers = document.querySelectorAll('th:has(.cbxContainer)');
        cbxContainers.forEach(item => {
            const label = item.querySelector('label');
            const dropdown = item.querySelector('.cbxContainer');
            if (!dropdown.contains(event.target) && !label.contains(event.target) && label.classList.contains('active')) {
                label.classList.remove('active');
            }
        });
    })

    function updateTable(prefix){
        const state = tableState[prefix];
        const container = document.getElementById(state.container);

        let params = new URLSearchParams();
        params.append('sort', state.sort)
        params.append('table', prefix === 't' ? 'available' : 'my');

        state.categories.forEach(c => params.append('category', c));
        state.statuses.forEach(s => params.append('status', s));

        container.style.opacity = '0.5';
        container.style.pointerEvents = 'none';

        fetch(`/support/tickets/partial/?${params.toString()}`)
            .then(res => res.text())
            .then(html => {
                container.innerHTML = html;
                container.style.opacity = '1';
                container.style.pointerEvents = 'auto';
            });
    }

    const sortable = ['created_at', 'title'];

    document.querySelectorAll(`th label[id]`).forEach(label => {
        label.addEventListener('click', () => {
            const [prefix, field] = label.id.split('-');
            const state = tableState[prefix];
            const wasActive = label.classList.contains('active');

            document.querySelectorAll(`th label[id^="${prefix}-"]`).forEach(l => {
                l.classList.remove('active');
                l.classList.remove('asc');
            });
            const fieldMap = {
                'Title': 'title',
                'CA': 'created_at',
                'cat': 'category',
                'stat': 'status',
            };

            if(sortable.includes(fieldMap[field])){
                label.classList.add('active');
                let dbField = fieldMap[field];
                
                if(state.sort == dbField){
                    state.sort= `-${dbField}`;
                    label.classList.remove('asc');
                }else{
                    state.sort = dbField;
                    label.classList.add('asc');
                }

                updateTable(prefix);
            }else{
                if(!wasActive){
                    label.classList.add('active');
                }
            }
        })
    });

    document.querySelectorAll('.cbxInput').forEach(input => {
        input.addEventListener('change', () => {
            const nameParts = input.name.split('-');
            const type = nameParts[0];
            const prefix = nameParts[1] === 'av' ? 't' : 'my';
            const state = tableState[prefix];
            const value = input.value;

            const targetArray = (type === 'category') ? state.categories : state.statuses;
            
            if(input.checked){
                if (!targetArray.includes(value)) targetArray.push(value);
            }else{
                const index = targetArray.indexOf(value);
                if(index > -1) targetArray.splice(index, 1);
            }
            updateTable(prefix);
        })
    })

    window.takeOwnership = function(ticketId) {
        if (!confirm("Do you want to take ownership of this ticket?")) return;
        fetch(`/support/tickets/take/${ticketId}/`, {
            method: 'POST',
            headers: {
                'X-CSRFToken': getCookie('csrftoken'), 
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                updateTable('t'); 
                updateTable('my');
            } else {
                alert(data.message || "Error taking ownership");
            }
        })
        .catch(error => console.error('Error:', error));
    }

    function getCookie(name) {
        let cookieValue = null;
        if (document.cookie && document.cookie !== '') {
            const cookies = document.cookie.split(';');
            for (let i = 0; i < cookies.length; i++) {
                const cookie = cookies[i].trim();
                if (cookie.substring(0, name.length + 1) === (name + '=')) {
                    cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                    break;
                }
            }
        }
        return cookieValue;
    }
})