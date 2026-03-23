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

document.querySelectorAll('.filterWrapper').forEach(selectInput => {
    const cbxContainer = selectInput.querySelector('.cbxContainer');
    const loading = selectInput.querySelector('.loading');
    const isNews = selectInput.closest('.newsContainer') !== null; 
    const containerType = isNews ? 'news' : 'banner';
    
    selectInput.addEventListener('click', (e) => {
        e.stopPropagation();
        cbxContainer.classList.add('active');
    });

    cbxContainer.addEventListener('change', () => {
        loading.classList.add('active');
        const selectedFilters = Array.from(cbxContainer.querySelectorAll('.cbxInput:checked'))
            .map(cbx => cbx.value);

        const params = new URLSearchParams(window.location.search);
        
        if (isNews) {
            params.set('news_page', '1');
            params.delete('visible-news'); 
            selectedFilters.forEach(val => params.append('visible-news', val));
        } else {
            params.set('banner_page', '1');
            params.delete('visible-banner');
            selectedFilters.forEach(val => params.append('visible-banner', val));
        }

        fetch(`${window.location.pathname}?${params.toString()}`, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(response => response.text())
        .then(html => {
            const parser = new DOMParser();
            const doc = parser.parseFromString(html, 'text/html');
            
            const targetSelector = isNews ? '#newsContainer' : '#bannerContainer';
            console.log("isNews", isNews)
            console.log(targetSelector)
            document.querySelector(targetSelector).innerHTML = doc.querySelector(targetSelector).innerHTML;
            
            loading.classList.remove('active');
            
            window.history.pushState({}, '', `${window.location.pathname}?${params.toString()}`);
        })
        .catch(error => {
            console.error('Filter Error:', error);
            loading.classList.remove('active');
        });
    })
});

document.addEventListener('click', () => {
    document.querySelectorAll('.cbxContainer.active').forEach(container => {
        container.classList.remove('active');
    });
});