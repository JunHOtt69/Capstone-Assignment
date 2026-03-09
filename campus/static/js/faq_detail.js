document.addEventListener('DOMContentLoaded', () => {
    const votePanel = document.querySelector('.faqVotePanel');
    if (!votePanel) {
        return;
    }

    const slug = votePanel.dataset.faqSlug;
    const isAuthenticated = votePanel.dataset.isAuthenticated === '1';
    const likeBtn = votePanel.querySelector('.likeBtn');
    const dislikeBtn = votePanel.querySelector('.dislikeBtn');
    const likesCount = votePanel.querySelector('[data-role="likes"]');
    const dislikesCount = votePanel.querySelector('[data-role="dislikes"]');

    const getCsrfToken = () => {
        const cookies = document.cookie ? document.cookie.split('; ') : [];
        for (const cookie of cookies) {
            if (cookie.startsWith('csrftoken=')) {
                return decodeURIComponent(cookie.split('=')[1]);
            }
        }
        return '';
    };

    const setActiveState = (userReaction) => {
        likeBtn?.classList.toggle('active', userReaction === 'like');
        dislikeBtn?.classList.toggle('active', userReaction === 'dislike');
    };

    const submitVote = async (reaction) => {
        if (!isAuthenticated) {
            window.alert('Please sign in to react to FAQs.');
            return;
        }

        if (!slug || votePanel.dataset.votePending === '1') {
            return;
        }

        votePanel.dataset.votePending = '1';
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

            if (likesCount) {
                likesCount.textContent = String(payload.n_likes);
            }
            if (dislikesCount) {
                dislikesCount.textContent = String(payload.n_dislikes);
            }
            setActiveState(payload.user_reaction || null);
        } catch (error) {
            window.alert('Unable to save your reaction right now.');
        } finally {
            votePanel.dataset.votePending = '0';
        }
    };

    likeBtn?.addEventListener('click', () => submitVote('like'));
    dislikeBtn?.addEventListener('click', () => submitVote('dislike'));
});
