document.addEventListener('DOMContentLoaded', () => {
    const faqPage = document.querySelector('.faqPage');
    const isAuthenticated = faqPage?.dataset.isAuthenticated === '1';

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

    const getCsrfToken = () => {
        const cookies = document.cookie ? document.cookie.split('; ') : [];
        for (const cookie of cookies) {
            if (cookie.startsWith('csrftoken=')) {
                return decodeURIComponent(cookie.split('=')[1]);
            }
        }
        return '';
    };

    const applyVoteState = (faqItem, userReaction) => {
        const likeBtn = faqItem.querySelector('.likeBtn');
        const dislikeBtn = faqItem.querySelector('.dislikeBtn');
        if (!likeBtn || !dislikeBtn) {
            return;
        }

        likeBtn.classList.toggle('active', userReaction === 'like');
        dislikeBtn.classList.toggle('active', userReaction === 'dislike');
    };

    const syncVoteCountsBySlug = (slug, payload) => {
        document.querySelectorAll(`.faqItem[data-faq-slug="${slug}"]`).forEach((card) => {
            const likeCount = card.querySelector('.likes .value');
            const dislikeCount = card.querySelector('.dislikes .value');
            if (likeCount) {
                likeCount.textContent = String(payload.n_likes);
            }
            if (dislikeCount) {
                dislikeCount.textContent = String(payload.n_dislikes);
            }
            applyVoteState(card, payload.user_reaction || null);
        });
    };

    const handleVoteClick = async (event) => {
        const voteBtn = event.target.closest('.voteBtn');
        if (!voteBtn) {
            return;
        }

        event.preventDefault();
        event.stopPropagation();

        if (!isAuthenticated) {
            window.alert('Please sign in to react to FAQs.');
            return;
        }

        const faqItem = voteBtn.closest('.faqItem');
        const slug = faqItem?.dataset.faqSlug;
        const reaction = voteBtn.dataset.reaction;
        if (!slug || !reaction) {
            return;
        }

        if (faqItem.dataset.votePending === '1') {
            return;
        }

        faqItem.dataset.votePending = '1';
        try {
            const response = await fetch(`/FAQs/${slug}/vote/`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': getCsrfToken(),
                    'X-Requested-With': 'XMLHttpRequest',
                },
                body: JSON.stringify({ reaction }),
            });

            const payload = await response.json();
            if (!response.ok || !payload.ok) {
                throw new Error(payload.error || 'Unable to save reaction.');
            }

            syncVoteCountsBySlug(slug, payload);
        } catch (error) {
            window.alert('Unable to save your reaction right now.');
        } finally {
            faqItem.dataset.votePending = '0';
        }
    };

    catContainer.addEventListener('click', handleVoteClick);
    const viewContainer = document.getElementById('viewFAQContainer');
    if (viewContainer) {
        viewContainer.addEventListener('click', handleVoteClick);
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
                suggestion.href = `/FAQs/${item.slug}/?from_click=1`;

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