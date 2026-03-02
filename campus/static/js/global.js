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


    const navItems = document.querySelectorAll('.navbarContent li');
    const navDropdown = document.querySelector('.navbarDropdown');
    const navContent = document.querySelector('.dropDownContentWrapper');
    const profileWrapper = document.getElementById('i-Profile');
    const header = document.querySelector('header');
    const templates = document.querySelectorAll('template');
    let transitionTimeout;
    let hoverTimeout;
    let navOpened = false;
    let isMouseHovering = false;
    let abortController = new AbortController();
    const templateMap = {};
    let currentTemplateId = null;

    templates.forEach(template => {
        templateMap[template.id] = template.content;
    });

    navItems.forEach(item => {
        item.addEventListener('mouseenter', () => {
            const link = item.querySelector('a');
            const template = templateMap[`${link.id}-dropdown`];
            const templateId = template? `${link.id}-dropdown`: null;
            toggleDropdown.open(navDropdown, template ? template : null, templateId, true);
        });
        
        item.addEventListener('mouseleave', () => {
            toggleDropdown.close(navDropdown);
        });
    });

    const toggleDropdown = {
        setHeight(element, heightVal) {
            
            const val = heightVal !== undefined? heightVal : element.querySelector('.dropDownContentWrapper').scrollHeight;
            element.style.setProperty('--dropdown-height', `${val}px`);
        },

        open(e, template, templateId, switchDropdown = false) {
            let timeout = 200;
            if(navOpened && currentTemplateId === templateId) return;
            if(switchDropdown && navOpened){
                timeout = 0;
            }
            clearTimeout(transitionTimeout);

            hoverTimeout = setTimeout(() => {
                abortController.abort();
                abortController = new AbortController();
                currentTemplateId = templateId; 
                
                if(switchDropdown && navOpened){
                    if(template){
                        let currentContents = Array.from(navContent.querySelectorAll('.functionG1, .functionG2, .profileG1, .cardContainer'));
                        currentContents.filter(item => item !== null);
                        if(currentContents.length > 0){
                            
                            requestAnimationFrame(async () => {
                                navContent.setAttribute('data-switching', 'start');

                                const transitionPromises = currentContents.map(item => {
                                    return new Promise(resolve => {
                                        const timer = setTimeout(resolve, 300);
                                        item.addEventListener('transitionend', () => {
                                            clearTimeout(timer);
                                            resolve(); 
                                        }, { once : true});
                                    });
                                });

                                await Promise.all(transitionPromises);

                                navContent.innerHTML = ``;
                                const clone = template.cloneNode(true);

                                navContent.appendChild(clone);
                                navContent.setAttribute('data-switching', 'none');
                                
                                requestAnimationFrame(() => {
                                    navOpened = true;
                                    formatCardId(e);
                                    this.setHeight(e);
                                    e.setAttribute('data-open', 'true');
                                    e.classList.add('animatingExtend'); 
                                    document.body.classList.toggle('nav-open', true);
                                    navContent.setAttribute('data-switching', 'end');

                                    e.addEventListener('transitionend', () => {
                                        e.classList.remove('animatingExtend');
                                    }, { once: true, signal: abortController.signal });
                                });
                                
                            });
                        };
                    }else{
                        navContent.innerHTML = ``;
                        console.log('no template');
                        currentTemplateId = null;
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
                        return;
                    }
                }

                else if(switchDropdown && !navOpened){
                    if(template){
                        navContent.innerHTML = ``;
                        const clone = template.cloneNode(true);

                        navContent.appendChild(clone);
                        navContent.setAttribute('data-switching', 'none');
                        
                        requestAnimationFrame(() => {
                            navOpened = true;
                            formatCardId(e);
                            this.setHeight(e);
                            e.setAttribute('data-open', 'true');
                            e.classList.add('animatingExtend'); 
                            document.body.classList.toggle('nav-open', true);
                            navContent.setAttribute('data-switching', 'end');

                            e.addEventListener('transitionend', () => {
                                e.classList.remove('animatingExtend');
                            }, { once: true, signal: abortController.signal });
                        });
                    }else{
                        navContent.innerHTML = ``;
                        console.log('no template');
                        currentTemplateId = null;
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
                        return;
                    }
                }

                const ItemR1 = navItems[0].getBoundingClientRect();
                const leftInVw = (ItemR1.left / window.innerWidth) * 100;
                if(leftInVw < 35) navContent.style.setProperty('--navItemLeft', `${ItemR1.left }px`);

                requestAnimationFrame(() => {
                    console.log('transitioning height');
                    this.setHeight(e);
                    e.setAttribute('data-open', 'true');
                    e.classList.add('animatingExtend'); 
                    document.body.classList.toggle('nav-open', true);

                    // Listen for the exact moment the transition ends
                    e.addEventListener('transitionend', () => {
                        e.classList.remove('animatingExtend');
                    }, { once: true, signal: abortController.signal });
                    navOpened = true;
                });
                
            }, timeout );
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
            }, 50);
        }
    };

    window.addEventListener('mousemove', (e) => {
        const rect = header.getBoundingClientRect();
        const dropdownRect = navDropdown.getBoundingClientRect();
        let insideX, insideY;

        insideX = e.clientX >= (rect.left + 20) && e.clientX <= (rect.right - 20);
        if(navOpened){
            insideY = e.clientY >= (rect.top + 10) && e.clientY <= dropdownRect.bottom;
        }else{
            insideY = e.clientY >= (rect.top + 10) && e.clientY <= rect.bottom;
        }

        isMouseHovering = insideX && insideY;
        if(navOpened && !isMouseHovering){
            isMouseHovering = false;
            toggleDropdown.close(navDropdown);
        }
    });

    navDropdown.addEventListener('mouseenter', () => toggleDropdown.open(navDropdown));
    navDropdown.addEventListener('mouseleave', () => toggleDropdown.close(navDropdown));

    profileWrapper.addEventListener('mouseenter', () => {
        let template = templateMap[`${profileWrapper.id}-dropdown`];
        const templateId = template? `${profileWrapper.id}-dropdown`: null;
        toggleDropdown.open(navDropdown, template ? template : null, templateId, true);
    });
    profileWrapper.addEventListener('mouseleave', () => toggleDropdown.close(navDropdown));
});


function removeNotification(notif) {
    if (!notif) return;
    
    notif.style.opacity = '0';
    notif.style.transition = 'opacity 1s ease';
    
    setTimeout(() => {
        notif.remove();
    }, 5000);
}

function formatCardId(container){
    const cardSpan = container.querySelector('#card_id');
    console.log(cardSpan);
    if(cardSpan && !cardSpan.dataset.formatted){
        const idText = cardSpan.innerText.trim();
        
        cardSpan.innerHTML = idText
        .split('')
        .map(char => `<span>${char}</span>`)
        .join('');
        cardSpan.dataset.formatted = 'true';
    }
}

