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