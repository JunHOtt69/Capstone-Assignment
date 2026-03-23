document.querySelectorAll('.newsAttachment').forEach(container => {
    const list = container.querySelector('.imgList');
    const items = container.querySelectorAll('.imgItem');
    const btnLeft = container.querySelector('.arrow.left');
    const btnRight = container.querySelector('.arrow.right');
    const dots = container.querySelectorAll('.dot');
    let currentIndex = 0;

    if(items.length == 1){
        btnLeft.style.display = 'none';
        btnRight.style.display = 'none';
        
        btnLeft.style.pointerEvents = 'none';
        btnRight.style.pointerEvents = 'none';
        
        dots.forEach(dot => {
            dot.style.display = 'none';
            dot.style.pointerEvents = 'none';
        })
        items[0].classList.toggle('active', true);
    }
    
    function updateCarousel() {
        items.forEach((item, index) => {
            item.classList.toggle('active', index === currentIndex);
        });

        dots.forEach((dot, index) => {
            dot.classList.toggle('active', index === currentIndex);
        });
        
        const itemWidth = items[0].offsetWidth + (parseFloat(getComputedStyle(list).gap) || 0);
        const offset = -currentIndex * itemWidth;
        
        list.style.transform = `translateX(${offset}px)`;
    }

    btnRight.addEventListener('click', () => {
        if (currentIndex < items.length - 1) {
            currentIndex++;
        } else {
            currentIndex = 0;
        }
        updateCarousel();
    });

    btnLeft.addEventListener('click', () => {
        if (currentIndex > 0) {
            currentIndex--;
        } else {
            currentIndex = items.length - 1; 
        }
        updateCarousel();
    });

    container.querySelectorAll('.dot').forEach(dot => {
        dot.addEventListener('click', (e) => {
            currentIndex = parseInt(e.target.dataset.index);
            updateCarousel();
        });
    });

    if(items.length > 0) updateCarousel();
});

