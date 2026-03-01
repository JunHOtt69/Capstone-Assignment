const navItems = document.querySelectorAll('.navbarContent li');
const navDropdown = document.querySelector('.navbarDropdown');
const navContent = document.querySelector('.dropDownContentWrapper');
const profileWrapper = document.querySelector('.profileWrapper');
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

            const ItemR1 = navItems[0].getBoundingClientRect();
            const leftInVw = (ItemR1.left / window.innerWidth) * 100;
            if(leftInVw < 30) navContent.style.setProperty('--navItemLeft', `${ItemR1.left }px`);

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
    });
    item.addEventListener('mouseleave', () => {
        toggleDropdown.close(navDropdown);
    });
});

window.addEventListener('mousemove', (e) => {
    const rect = header.getBoundingClientRect();
    const dropdownRect = navDropdown.getBoundingClientRect();
    let insideX, insideY;

    insideX = e.clientX >= (rect.left + 20) && e.clientX <= (rect.right - 20);
    if(navOpened){
        insideY = e.clientY >= (rect.top + 20) && e.clientY <= dropdownRect.bottom;
    }else{
        insideY = e.clientY >= (rect.top + 20) && e.clientY <= rect.bottom;
    }

    isMouseHovering = insideX && insideY;
    if(navOpened && !isMouseHovering){
        isMouseHovering = false;
        toggleDropdown.close(navDropdown);
    }
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