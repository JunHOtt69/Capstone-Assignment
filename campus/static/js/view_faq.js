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
})

document.addEventListener('click', (event) => {
    const suggestionsList = document.getElementById('faqSuggestions');
    
    if (!suggestionsList.contains(event.target)) {
        suggestionsList.classList.toggle('visible', false);
    }
});