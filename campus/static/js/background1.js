window.addEventListener('load', function() {
    const bgContainer = document.getElementById('background');
    
    const fixedWidth = bgContainer.clientWidth;
    const fixedHeight = bgContainer.clientHeight;
    
    let colorbg = new Color4Bg.BlurDotBg({
        dom: "background", 
        colors: ["#1a1a1a", "#ffffff", "#000000", "#ffffff"],
        loop: true
    });

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