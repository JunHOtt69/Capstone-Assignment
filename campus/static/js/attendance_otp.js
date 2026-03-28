let is_submitting = false;

function renderAttendancePie() {
	const ctx = document.getElementById("attendancePie");
	if (!ctx) return;

	const present = parseInt(document.getElementById("present-count")?.textContent || 0);
	const late = parseInt(document.getElementById("late-count")?.textContent || 0);
	const absent = parseInt(document.getElementById("absent-count")?.textContent || 0);

	if (window.attendancePieInstance) {
		window.attendancePieInstance.destroy();
	}

	window.attendancePieInstance = new Chart(ctx, {
		type: "pie",
		data: {
		labels: ["Present", "Late", "Absent"],
		datasets: [{
			data: [present, late, absent],
			backgroundColor: ["#4CAF50", "#FFC107", "#f52314"]
		}]
		}
	});
}

function refreshAttendancePie() {
	const wrapper = document.getElementById("attendance-pie-wrapper");
    const url = wrapper.dataset.url; 

    fetch(url)
		.then(response => response.text())
		.then(html => {
			document.getElementById("attendance-pie-wrapper").innerHTML = html;
			renderAttendancePie();
			startCountdown();
		})
		.catch(error => {
		console.error("Failed to refresh pie chart partial:", error);
		});
}

function refreshStudentList() {
    const wrapper = document.getElementById("attendance-student-list-wrapper");
    const url = wrapper.dataset.url; 

	fetch(url)
		.then(response => response.text())
		.then(html => {
		document.getElementById("attendance-student-list-wrapper").innerHTML = html;
		})
		.catch(error => {
		console.error("Failed to refresh student list partial:", error);
		});
}

function startCountdown() {
	const countdownEl = document.getElementById("countdown");
	const pieData = document.getElementById("attendance-pie-data");
    const countWrapper = document.querySelector(".countWrapper");
	
	if (!countdownEl || !pieData){
		return
	};

	const createdAtStr = pieData.dataset.createdAt;
	if (!createdAtStr) return;

	const createdAt = new Date(createdAtStr).getTime();
	const ttlMs = 60 * 1000;

	function updateCountdown() {
		const now = new Date().getTime();
		const expiryTime = createdAt + ttlMs;
		const distance = expiryTime - now;

		if (distance <= 0) {
			countdownEl.textContent = "0";
			countWrapper.style.setProperty('--progress', '0%');

			if (window.attendanceCountdownInterval) {
				clearInterval(window.attendanceCountdownInterval);
			}

			refreshAttendancePie();
			return;
		}

		const seconds = Math.floor(distance / 1000);
		countdownEl.textContent = seconds;

        const percentage = (distance / ttlMs) * 100;
        countWrapper.style.setProperty('--progress', `${percentage}%`);
	}

	updateCountdown();

	if (window.attendanceCountdownInterval) {
		clearInterval(window.attendanceCountdownInterval);
	}

	window.attendanceCountdownInterval = setInterval(updateCountdown, 1000);
}

document.addEventListener("DOMContentLoaded", function () {
	startCountdown();
	renderAttendancePie();

    const closeForm = document.getElementById('close');
    if (closeForm) {
        closeForm.addEventListener('submit', function() {
            is_submitting = true; 
        });
    }

    startRealTimeUpdates();
	document.addEventListener("submit", function (e) {
		const form = e.target;

		if (form.classList.contains("mark-attendance-form")) {
		e.preventDefault();

		const clickedButton = e.submitter;
		const formData = new FormData(form);

		if (clickedButton && clickedButton.name === "status") {
			formData.append("status", clickedButton.value);
		}

        const wrapper = document.getElementById("markStudentAttendance");
        const url = wrapper.dataset.url; 
    
		fetch(url , {
			method: "POST",
			body: formData,
			headers: {
			"X-Requested-With": "XMLHttpRequest"
			}
		})
		.then(response => {
			if (!response.ok) {
			throw new Error("Failed to mark attendance.");
			}
			return response.text();
		})
		.then(() => {
			refreshAttendancePie();
			refreshStudentList();
		})
		.catch(error => {
			console.error(error);
			alert("Failed to update attendance.");
		});
		}
	});
});

window.addEventListener('beforeunload', function (e) {
    if (window.attendanceCountdownInterval) {
        clearInterval(window.attendanceCountdownInterval);
    }

    const formWrapper = document.querySelector('.formWrapper');
    
    if (formWrapper && formWrapper.getAttribute('data-session') === 'open') {
        if(!is_submitting){
            e.preventDefault();
            e.returnValue = '';
        }
        
        const closeForm = formWrapper.querySelector('#close');
        const dynamicCloseUrl = closeForm.getAttribute('action');

        const csrfToken = document.querySelector('[name=csrfmiddlewaretoken]').value;

        fetch(dynamicCloseUrl, {
            method: 'POST',
            headers: {
                'X-CSRFToken': csrfToken,
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                'action': 'close_session' 
            }),
            keepalive: true 
        });
    }
});

function startRealTimeUpdates() {
    const formWrapper = document.querySelector('.formWrapper');
    
    const updateInterval = setInterval(() => {
        const isSessionOpen = formWrapper && formWrapper.getAttribute('data-session') === 'open';

        if (isSessionOpen) {
            refreshAttendancePie();
            refreshStudentList();
        } else {
            clearInterval(updateInterval); 
        }
    }, 5000); 

    window.attendanceUpdateInterval = updateInterval;
}
