document.addEventListener("DOMContentLoaded", function() {
    const tagsContainer = document.querySelector('.tags');
    const total = parseInt(tagsContainer.getAttribute('data-total')) || 0;
    
    if (total === 0) return;

    const segments = [
        { id: 'circle_in_progress', attr: 'data-in_progress' },
        { id: 'circle_escalate',    attr: 'data-escalated' },
        { id: 'circle_resolved',    attr: 'data-resolved' },
        { id: 'circle_close',       attr: 'data-closed' }
    ];

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
            circle.style.strokeDashoffset = -accumulatedPercent * maxPath;
            
            accumulatedPercent += percent;
        }
    });
});