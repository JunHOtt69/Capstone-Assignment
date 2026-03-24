window.addEventListener('load', function() {
    const bgContainer = document.getElementById('background');

    if (!bgContainer) {
        console.error("Element with ID 'background' not found.");
        return;
    }

    const fixedWidth = bgContainer.clientWidth;
    const fixedHeight = bgContainer.clientHeight;
    
    let colorbg = new Color4Bg.AmbientLightBg({
        dom: "background", 
        colors: ["#79b322","#75ff7e","#adff2f","#9effae","#feffc6","#ecfef4"],
        loop: true
    });

    colorbg.update("darkness", 1);

    colorbg._getParentRect = function() {
        return {
            w: fixedWidth,
            h: fixedHeight
        };
    };

    colorbg.resize = function() {
        return false; 
    };

    const canvas = bgContainer.querySelector('canvas');
    if (canvas) {
        canvas.style.width = fixedWidth + "px";
        canvas.style.height = fixedHeight + "px";
    }
});