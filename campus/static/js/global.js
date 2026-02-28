const navItems = document.querySelectorAll('.navbarContent li')
const navDropdown = document.querySelector('.navbarDropdown')
const profileWrapper = document.querySelector('.profileWrapper')
const header = document.querySelector('header');
let transitionTimeout;
let hoverTimeout;
let navOpened = false;
let isMouseHovering = false;
let abortController = new AbortController();

const toggleDropdown = {
    setHeight(element, heightVal) {
        const val = heightVal !== undefined? heightVal : element.querySelector('.dropDownContentWrapper').scrollHeight;
        element.style.setProperty('--dropdown-height', `${val}px`);
    },

    open(e) {
        clearTimeout(transitionTimeout);

        hoverTimeout = setTimeout(() => {
            abortController.abort();
            abortController = new AbortController();
            navOpened = true;

            requestAnimationFrame(() => {
                this.setHeight(e);
                e.setAttribute('data-open', 'true');
                e.classList.add('animatingExtend'); 
                document.body.classList.add('nav-open');

                // Listen for the exact moment the transition ends
                e.addEventListener('transitionend', () => {
                    e.classList.remove('animatingExtend');
                }, { once: true, signal: abortController.signal });
            });
            
        }, 200);
    },

    close(e){
        clearTimeout(hoverTimeout);
        clearTimeout(transitionTimeout);

        transitionTimeout = setTimeout(() => {
            if(isMouseHovering) return;
            abortController.abort();
            abortController = new AbortController();
            navOpened = false;
            requestAnimationFrame(() => {
                e.setAttribute('data-open', 'false');
                e.classList.add('animatingShrink');
                document.body.classList.remove('nav-open');
                
                this.setHeight(e, 0);

                e.addEventListener('transitionend', () => {
                    e.classList.remove('animatingShrink');
                }, { once: true, signal: abortController.signal });
            })
        }, 150);
    }
};

navItems.forEach(item => {
    item.addEventListener('mouseenter', () => {
        toggleDropdown.open(navDropdown);
        console.log('extending');
    });
    item.addEventListener('mouseleave', () => {
        toggleDropdown.close(navDropdown);
        console.log('shrinking');
    });
});

header.addEventListener('mousemove', () => { 
    if(!navOpened) return;
    else if(navOpened) isMouseHovering = true;
});

header.addEventListener('mouseleave', () => { 
    if(navOpened) isMouseHovering = false;
});

navDropdown.addEventListener('mouseenter', () => toggleDropdown.open(navDropdown));
navDropdown.addEventListener('mouseleave', () => toggleDropdown.close(navDropdown));

profileWrapper.addEventListener('mouseenter', () => toggleDropdown.open(navDropdown));
profileWrapper.addEventListener('mouseleave', () => toggleDropdown.close(navDropdown));



document.addEventListener('click', (event) => {
    navItems.forEach(item => {
        if (!item.contains(event.target)) {
            toggleDropdown.close(navDropdown);
        }
    });

    if (!navDropdown.contains(event.target)) {
        toggleDropdown.close(navDropdown);
    }

    if(!profileWrapper.contains(event.target)) {
        toggleDropdown.close(navDropdown);
    }
});


const cardSpan = document.getElementById('card_id');
const idText = cardSpan.innerText.trim();

cardSpan.innerHTML = idText
    .split('')
    .map(char => `<span>${char}</span>`)
    .join('')


document.addEventListener('DOMContentLoaded', () => {
    const notifications = document.querySelectorAll('.notifContainer .notif');

    notifications.forEach(notif => {
        const closeBtn = notif.querySelector('.closeBtn');
        closeBtn.addEventListener('click', () => {
            removeNotification(notif);
        });

        setTimeout(() => {
            removeNotification(notif);
        }, 5000);
    });
});



function removeNotification(notif) {
    if (!notif) return;
    
    notif.style.opacity = '0';
    notif.style.transition = 'opacity 1s ease';
    
    setTimeout(() => {
        notif.remove();
    }, 5000);
}