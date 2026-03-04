document.addEventListener('DOMContentLoaded', function () {
	const categories = {
		centrepoint: 'CENTREPOINT & ATRIUM',
		auditoriums: 'AUDITORIUMS',
		classrooms: 'CLASSROOMS',
		itlabs: 'IT LABS',
		library: 'LIBRARY',
		cafeteria: 'CAFETERIA'
	};

	const buttons = Array.from(document.querySelectorAll('.poi-cat-btn'));
	const gallery = document.getElementById('poi-gallery');

	function seedsFor(cat) {
		return Array.from({ length: 8 }, (_, i) => `${cat}-${i + 1}`);
	}

	function renderCategory(cat) {
		if (!gallery) return;
		gallery.innerHTML = '';
		const seeds = seedsFor(cat);
		seeds.forEach(seed => {
			const card = document.createElement('div');
			card.className = 'poi-card';
			const img = document.createElement('img');
			img.src = `https://picsum.photos/seed/${encodeURIComponent(seed)}/800/600`;
			img.alt = `${categories[cat] || cat} image`;
			card.appendChild(img);
			gallery.appendChild(card);
		});
	}

	buttons.forEach(btn => {
		btn.addEventListener('click', () => {
			buttons.forEach(b => b.classList.remove('active'));
			btn.classList.add('active');
			const cat = btn.dataset.cat;
			renderCategory(cat);
		});
	});

	const initial = document.querySelector('.poi-cat-btn.active') || buttons[0];
	if (initial) renderCategory(initial.dataset.cat);
});
