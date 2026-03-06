let selection = { category: null, room: null, time: null };

const rooms = {
    'Classroom': ['C-101', 'C-102', 'C-103', 'C-104','C-105', 'C-106', 'C-107', 'C-108', 'C-109', 'C-110','C-111', 'C-112'],
    'Meeting Room': ['Meeting Room A', 'Meeting Room B', 'Meeting Room C', 'Meeting Room D','Meeting Room E', 'Meeting Room F', 'Meeting Room G', 'Meeting Room H'],
    'Lecture Hall': ['Theater A', 'Main Hall', 'Auditorium']
};

function selectCategory(btn, cat) {
    // UI Update
    document.querySelectorAll('.cat-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    
    // Logic Reset
    selection.category = cat;
    selection.room = null;
    selection.time = null;

    // Show Room Section
    const roomSection = document.getElementById('roomSection');
    const roomGrid = document.getElementById('roomGrid');
    roomSection.classList.remove('hidden');
    document.getElementById('timeSection').classList.add('hidden');
    
    roomGrid.innerHTML = '';
    rooms[cat].forEach(r => {
        const rBtn = document.createElement('button');
        rBtn.className = 'btn room-btn';
        rBtn.innerText = r;
        rBtn.onclick = () => selectRoom(rBtn, r);
        roomGrid.appendChild(rBtn);
    });
    updateUI();
}

function selectRoom(btn, roomName) {
    document.querySelectorAll('.room-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    selection.room = roomName;
    selection.time = null;

    document.getElementById('timeSection').classList.remove('hidden');
    renderTimes();
    updateUI();
}

function renderTimes() {
    const grid = document.getElementById('timeGrid');
    grid.innerHTML = '';
    
    let curr = new Date();
    curr.setHours(10, 0, 0); // 10:00 AM
    const end = new Date();
    end.setHours(17, 0, 0); // 5:00 PM

    while(curr <= end) {
        const tStr = curr.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false });
        const tBtn = document.createElement('button');
        tBtn.className = 'time-btn';
        tBtn.innerText = tStr;
        tBtn.onclick = () => {
            document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('selected'));
            tBtn.classList.add('selected');
            selection.time = tStr;
            updateUI();
        };
        grid.appendChild(tBtn);
        curr.setMinutes(curr.getMinutes() + 30);
    }
}

function updateUI() {
    const sum = document.getElementById('summary');
    const btn = document.getElementById('confirmBtn');
    if(selection.category && selection.room && selection.time) {
        sum.innerHTML = `Ready to book <strong>${selection.room}</strong> at <strong>${selection.time}</strong>`;
        btn.disabled = false;
    } else {
        sum.innerText = selection.room ? `Room: ${selection.room}. Pick a time block.` : "Select options above to continue...";
        btn.disabled = true;
    }
}

function bookNow() {
    // Update History Table
    document.getElementById('historyPlaceholder').classList.add('hidden');
    document.getElementById('historyTable').classList.remove('hidden');

    const body = document.getElementById('historyBody');
    const row = body.insertRow(0);
    row.innerHTML = `
        <td>${selection.room}</td>
        <td>${selection.time}</td>
        <td style="color:var(--yellowgreen); font-weight:bold;">Confirmed</td>
    `;

    alert(`Reservation Confirmed for ${selection.room}!`);
    
    // Optional: Reset form for next booking
    resetForm();
}

function resetForm() {
    selection = { category: null, room: null, time: null };
    document.querySelectorAll('.btn, .time-btn').forEach(b => b.classList.remove('active', 'selected'));
    document.getElementById('roomSection').classList.add('hidden');
    document.getElementById('timeSection').classList.add('hidden');
    updateUI();
}