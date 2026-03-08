document.addEventListener('DOMContentLoaded', async() => {
    const searchInput = document.getElementById('faqSearch');
    const suggestionsList = document.getElementById('faqSuggestions');

    searchInput.addEventListener('input', function() {
        const query = this.value;

        if (query.length < 2) {
            suggestionsList.classList.toggle('visible', false);
            suggestionsList.innerHTML = '';
            return;
        }else{
            suggestionsList.classList.toggle('visible', true);
        }

        fetch(`/suggestions/?q=${encodeURIComponent(query)}`)
            .then(response => response.json())
            .then(data => {
                suggestionsList.innerHTML = '';

                if(data.suggestions.length > 0){
                    data.suggestions.forEach(item => {
                        const suggestion = document.createElement('a');
                        suggestion.className = 'suggestion';
                        suggestion.href = `/FAQs/${item.slug}/`;
                        
                        const suggestionTitle = document.createElement('p');
                        suggestionTitle.className = 'suggestionTitle';
                        
                        const suggestionCat = document.createElement('span');
                        suggestionCat.className = 'suggestionCat';
                        
                        suggestionTitle.innerText = item.title;
                        suggestionCat.innerText = item.category;

                        suggestion.appendChild(suggestionTitle);
                        suggestion.appendChild(suggestionCat);
                        suggestionsList.appendChild(suggestion);
                    });
                }else{
                    const empty = document.createElement('div');
                    empty.className = 'suggestion';
                    empty.style.setProperty('font-size', 'var(--p-fontsize');
                    empty.style.setProperty('color', 'rgba(var(--black), 0.4)');
                    
                    empty.innerText ='No matching suggestions. Press Enter to search for more results.'
                    suggestionsList.appendChild(empty);
                }
            });
    });

    let currentCatPage = 1;
    const catContainer = document.querySelector('#catFAQContainer');
    const pageWrapper = document.querySelector('.browseCategory .pageWrapper');
    const categoryInputs = document.querySelectorAll('.categoryInput');

    categoryInputs.forEach(input => {
        input.addEventListener('change', () => {
            currentCatPage = 1; 
            fetchFilteredFAQs();
        });
    });

    const prevBtn = document.getElementById('prevPage');
    const nextBtn = document.getElementById('nextPage');

    if (prevBtn) {
        prevBtn.addEventListener('click', () => fetchCategoryPage(-1));
    }
    if (nextBtn) {
        nextBtn.addEventListener('click', () => fetchCategoryPage(1));
    }

    function fetchFilteredFAQs() {
        const selected = Array.from(categoryInputs)
            .filter(i => i.checked)
            .map(i => `category=${encodeURIComponent(i.value)}`)
            .join('&');

        const url = `/FAQs/?page=${currentCatPage}${selected ? '&' + selected : ''}`;

        fetch(url, {
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        })
        .then(response => {
            const serverMaxPages = response.headers.get('X-Max-Pages');
            if (serverMaxPages) {
                document.querySelector('#maxPages').value = serverMaxPages;
            }
            return response.text();
        })
        .then(html => {
            catContainer.innerHTML = html;
            const newMax = parseInt(document.querySelector('#maxPages').value);
            updateUI(newMax);
        });
    }

    function fetchCategoryPage(pageIncrement) {
        const maxPages = parseInt(document.querySelector('#maxPages').value);
        const nextPage = currentCatPage + pageIncrement;

        if (nextPage < 1 || nextPage > maxPages) return;

        currentCatPage = nextPage;
        fetchFilteredFAQs(); 
    }

    function updateUI(maxPages) {
        const pageNumDisplay = document.querySelector('#pageNumbers');
        if (pageNumDisplay) {
            pageNumDisplay.innerText = `${currentCatPage} / ${maxPages}`;
        }

        if (maxPages > 1) {
            pageWrapper.classList.add('active');
        } else {
            pageWrapper.classList.remove('active');
        }

        prevBtn.disabled = (currentCatPage === 1);
        nextBtn.disabled = (currentCatPage === maxPages);
    }
})

document.addEventListener('click', (event) => {
    const suggestionsList = document.getElementById('faqSuggestions');
    
    if (!suggestionsList.contains(event.target)) {
        suggestionsList.classList.toggle('visible', false);
    }
});