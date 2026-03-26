document.addEventListener("DOMContentLoaded", function () {
    const templateIds = [
        'memberLJH', 
        'memberMYS', 
        'memberLZS', 
        'memberABRAR', 
        'memberEanan', 
        'memberFawaz'
    ];

    let currentIndex = 0;
    const teamContent = document.querySelector('.teamContent');
    const memberContainer = teamContent.querySelector('.member'); 
    const dots = document.querySelectorAll('.dot');
    const leftArrow = document.querySelector('.arrow.left');
    const rightArrow = document.querySelector('.arrow.right');
    let autoPlayTimer = null;

    function updateMember(index, isInitial = false) {
        const template = document.getElementById(templateIds[index]);
        if (!template) return;

        const clone = template.content.cloneNode(true);
        const newMemberContent = clone.querySelector('.member').innerHTML;

        if (isInitial) {
            memberContainer.innerHTML = newMemberContent;
            memberContainer.classList.add('active');
            updateDots(index);
            return;
        }

        memberContainer.classList.remove('active');
        memberContainer.classList.add('switching');

        setTimeout(() => {
            memberContainer.innerHTML = newMemberContent;

            memberContainer.classList.remove('switching');
            memberContainer.classList.add('prepare');

            void memberContainer.offsetWidth;

            memberContainer.classList.remove('prepare');
            memberContainer.classList.add('active');
            
            updateDots(index);
        }, 400); 
    }

    function updateDots(index) {
        dots.forEach(dot => dot.classList.remove('active'));
        dots[index].classList.add('active');
    }

    function startAutoPlay() {
        stopAutoPlay(); 
        
        autoPlayTimer = setInterval(() => {
            nextMember();
        }, 30000);
    }

    function stopAutoPlay() {
        if (autoPlayTimer) {
            clearInterval(autoPlayTimer);
        }
    }

    function resetTimer() {
        stopAutoPlay();
        startAutoPlay();
    }

    function nextMember() {
        currentIndex = (currentIndex + 1) % templateIds.length;
        updateMember(currentIndex);
    }

    function prevMember() {
        currentIndex = (currentIndex - 1 + templateIds.length) % templateIds.length;
        updateMember(currentIndex);
    }

    rightArrow.addEventListener('click', () => {
        nextMember();
        resetTimer(); // Reset countdown on click
    });

    leftArrow.addEventListener('click', () => {
        prevMember();
        resetTimer(); 
    });

    dots.forEach((dot, index) => {
        dot.addEventListener('click', () => {
            if (currentIndex === index) return;
            currentIndex = index;
            updateMember(currentIndex);
            resetTimer(); 
        });
    });


    const section4 = document.querySelector('#section4');
    const teamTitle = document.querySelector('.teamTitle');
    const header = document.querySelector('header');
    const bannerTicker = document.querySelector('.bannerTicker');
    
    const scrollContainer = document.querySelector('.mainScrollWrapper') || window;

    const MAX_SCALE = 6;
    const MIN_SCALE = 1;

    function handleZoomScroll() {
        const stickyHeight = header.offsetHeight + bannerTicker.offsetHeight;
        const sectionRect = section4.getBoundingClientRect();
        
        const startPoint = window.innerHeight; 
        const endPoint = stickyHeight * 2.5;

        let distance = sectionRect.top - endPoint;
        let totalDistance = startPoint - endPoint;

        let progress = Math.min(Math.max(distance / totalDistance, 0), 1);

        if (sectionRect.top < window.innerHeight && sectionRect.bottom > 0) {
            const currentScale = MIN_SCALE + (progress * (MAX_SCALE - MIN_SCALE));
            teamTitle.style.transform = `scale(${currentScale})`;
            teamTitle.style.opacity = 1 - (progress * 0.8); 
        }
    }

    scrollContainer.addEventListener('scroll', handleZoomScroll, { passive: true });
    
    handleZoomScroll();

    updateMember(0, true);
    startAutoPlay();
});