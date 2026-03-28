document.addEventListener('DOMContentLoaded', () => {
    const tagsContainer = document.querySelector('.tags');
    if (!tagsContainer) return;

    const total = parseInt(tagsContainer.getAttribute('data-total')) || 0;
    if (total === 0) return;

    const segments = [
        { id: 'circle_present', attr: 'data-present'},
        { id: 'circle_late',    attr: 'data-late'},
        { id: 'circle_absent',  attr: 'data-absent'}
    ];

    let sumOfParts = 0;
    segments.forEach(item => {
        const tagEl = document.querySelector(`[${item.attr}]`);
        if (tagEl) {
            sumOfParts += parseInt(tagEl.getAttribute(item.attr)) || 0;
        }
    });

    if (sumOfParts !== total) {
        console.error(`SmartCampus Error: Attendance count mismatch! Total: ${total}, Sum of Parts: ${sumOfParts}. Chart will not render.`);
        segments.forEach(item => {
            const circle = document.getElementById(item.id);
            if (circle) circle.style.display = 'none';
        });
        return; 
    }

    const maxPath = 125.6;
    let accumulatedPercent = 0;

    segments.forEach(item => {
        const circle = document.getElementById(item.id);
        const tagEl = document.querySelector(`[${item.attr}]`);
        
        if (circle && tagEl) {
            const val = parseInt(tagEl.getAttribute(item.attr)) || 0;
            const percent = val / total;
            const segmentLength = percent * maxPath;
            
            circle.style.strokeDasharray = `${segmentLength} ${maxPath * 2}`;
            
            circle.style.strokeDashoffset = -(accumulatedPercent * maxPath);
            
            accumulatedPercent += percent;
        }
    });
});