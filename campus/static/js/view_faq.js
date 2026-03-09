document.addEventListener('DOMContentLoaded', () => {
    const searchInput = document.getElementById('faqSearch');
    const suggestionsList = document.getElementById('faqSuggestions');
    const searchContainer = document.querySelector('.searchContainer');

    const pageNumDisplay = document.getElementById('pageNumbers');
    const maxPagesInput = document.getElementById('maxPages');
    const prevBtn = document.getElementById('prevPage');
    const nextBtn = document.getElementById('nextPage');
    const catContainer = document.getElementById('catFAQContainer');
    const pageWrapper = document.querySelector('.browseCategory .pageWrapper');
    const categoryInputs = document.querySelectorAll('.categoryInput');

    if (!searchInput || !suggestionsList || !catContainer || !maxPagesInput) {
        return;
    }

    const parsedCurrent = pageNumDisplay
        ? parseInt((pageNumDisplay.innerText || '1').split('/')[0], 10)
        : 1;
    let currentCatPage = Number.isFinite(parsedCurrent) ? parsedCurrent : 1;
    let activeSuggestionHref = null;
    let suggestionRequestId = 0;

    const hideSuggestions = () => {
        suggestionsList.classList.remove('visible');
    };

    const renderSuggestions = (suggestions) => {
        suggestionsList.innerHTML = '';
        activeSuggestionHref = null;

        if (suggestions.length > 0) {
            suggestions.forEach((item, index) => {
                const suggestion = document.createElement('a');
                suggestion.className = 'suggestion';
                suggestion.href = `/FAQs/${item.slug}/`;

                if (index === 0) {
                    activeSuggestionHref = suggestion.href;
                }

                const suggestionTitle = document.createElement('p');
                suggestionTitle.className = 'suggestionTitle';
                suggestionTitle.innerText = item.title;

                const suggestionCat = document.createElement('span');
                suggestionCat.className = 'suggestionCat';
                suggestionCat.innerText = item.category;

                suggestion.appendChild(suggestionTitle);
                suggestion.appendChild(suggestionCat);
                suggestionsList.appendChild(suggestion);
            });
            suggestionsList.classList.add('visible');
            return;
        }

        const empty = document.createElement('div');
        empty.className = 'suggestion';
        empty.style.setProperty('font-size', 'var(--p-fontsize)');
        empty.style.setProperty('color', 'rgba(var(--black), 0.45)');
        empty.innerText = 'No matching suggestions.';
        suggestionsList.appendChild(empty);
        suggestionsList.classList.add('visible');
    };

    const fetchSuggestions = async (query) => {
        const requestId = ++suggestionRequestId;
        try {
            const response = await fetch(`/suggestions/?q=${encodeURIComponent(query)}`);
            const data = await response.json();

            // Prevent out-of-order responses from replacing newer results.
            if (requestId !== suggestionRequestId) {
                return;
            }

            renderSuggestions(data.suggestions || []);
        } catch (error) {
            suggestionsList.innerHTML = '';
            hideSuggestions();
        }
    };

    searchInput.addEventListener('input', (event) => {
        const query = event.target.value.trim();

        if (query.length < 2) {
            suggestionsList.innerHTML = '';
            hideSuggestions();
            return;
        }

        fetchSuggestions(query);
    });

    searchInput.addEventListener('keydown', (event) => {
        if (event.key !== 'Enter') {
            return;
        }

        if (suggestionsList.classList.contains('visible') && activeSuggestionHref) {
            event.preventDefault();
            window.location.href = activeSuggestionHref;
        }
    });

    const searchIcon = document.querySelector('.searchBar .searchIcon');
    if (searchIcon) {
        searchIcon.addEventListener('click', () => searchInput.focus());
    }

    document.addEventListener('click', (event) => {
        if (!searchContainer.contains(event.target)) {
            hideSuggestions();
        }
    });

    const updateUI = (maxPages) => {
        if (pageNumDisplay) {
            pageNumDisplay.innerText = `${currentCatPage} / ${maxPages}`;
        }

        if (pageWrapper) {
            pageWrapper.classList.toggle('active', maxPages > 1);
        }

        if (prevBtn) {
            prevBtn.disabled = currentCatPage === 1;
        }
        if (nextBtn) {
            nextBtn.disabled = currentCatPage === maxPages;
        }
    };

    const fetchFilteredFAQs = async () => {
        const selected = Array.from(categoryInputs)
            .filter((input) => input.checked)
            .map((input) => `category=${encodeURIComponent(input.value)}`)
            .join('&');

        const url = `/FAQs/?page=${currentCatPage}${selected ? `&${selected}` : ''}`;

        try {
            const response = await fetch(url, {
                headers: { 'X-Requested-With': 'XMLHttpRequest' }
            });

            const serverMaxPages = parseInt(response.headers.get('X-Max-Pages'), 10);
            if (Number.isFinite(serverMaxPages)) {
                maxPagesInput.value = serverMaxPages;
                if (currentCatPage > serverMaxPages) {
                    currentCatPage = serverMaxPages;
                }
            }

            const html = await response.text();
            catContainer.innerHTML = html;

            const newMax = parseInt(maxPagesInput.value, 10) || 1;
            updateUI(newMax);
        } catch (error) {
            // Keep current content rendered if fetch fails.
        }
    };

    const fetchCategoryPage = (pageIncrement) => {
        const maxPages = parseInt(maxPagesInput.value, 10) || 1;
        const nextPage = currentCatPage + pageIncrement;

        if (nextPage < 1 || nextPage > maxPages) {
            return;
        }

        currentCatPage = nextPage;
        fetchFilteredFAQs();
    };

    categoryInputs.forEach((input) => {
        input.addEventListener('change', () => {
            currentCatPage = 1;
            fetchFilteredFAQs();
        });
    });

    if (prevBtn) {
        prevBtn.addEventListener('click', () => fetchCategoryPage(-1));
    }
    if (nextBtn) {
        nextBtn.addEventListener('click', () => fetchCategoryPage(1));
    }

    const initialMax = parseInt(maxPagesInput.value, 10) || 1;
    updateUI(initialMax);
});