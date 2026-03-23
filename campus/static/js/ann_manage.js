document.addEventListener('DOMContentLoaded', function() {
    
    function updateAnnouncementPage(target, page) {
        let params = new URLSearchParams();
        params.append(`${target}_page`, page);
        params.append(`target`, target);

        fetch(`/announcements/manage/?${params.toString()}`, {
            headers: {
                'x-requested-with': 'XMLHttpRequest'
            }
        })
        .then(response => response.text())
        .then(html => {
            const container = document.getElementById(`${target}Container`);
            container.innerHTML = html;

            const control = document.getElementById(`${target}_currentPage`);
            const maxPages = parseInt(control.dataset.maxPages);

            control.dataset.currentPage = page;

            const pageLabel = control.querySelector('.pageNumbers');
            if(pageLabel){
                pageLabel.innerText = `${page} / ${maxPages}`;
            }

            const nextbtn = control.querySelector('.next.pageBtn');
            const previousbtn = control.querySelector('.previous.pageBtn');
            if(nextbtn) nextbtn.disabled = (page >= maxPages);
            if(previousbtn) previousbtn.disabled = (page <= 1);
        })
        .catch(error => console.warn('Error updating pagination:', error));
    }

    document.body.addEventListener('click', function(e) {
        if (e.target.classList.contains('pageBtn')) {
            const isNext = e.target.classList.contains('next');
            const container = e.target.closest('.newsContainer') ? 'news' : 'banner';
            
            const control = document.getElementById(`${container}_currentPage`);
            let currentPage = parseInt(control.dataset.currentPage);
            let maxPages = parseInt(control.dataset.maxPages);

            let newPage = isNext ? currentPage + 1 : currentPage - 1;
            if(newPage >= 1 && newPage <= maxPages){
                updateAnnouncementPage(container, newPage);
            }
        }
        
    });
});