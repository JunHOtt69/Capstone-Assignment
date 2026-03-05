document.addEventListener('DOMContentLoaded', function () {
	const categoriesContainer = document.getElementById('poi-categories');
	const gallery = document.getElementById('poi-gallery');
	const editor = document.getElementById('poi-editor');
	const isAdmin = !!editor;

	const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

	let poiData = {};

	function slugify(s){ return s.toString().toLowerCase().trim().replace(/\s+/g,'-').replace(/[^a-z0-9\-]/g,''); }

	function createButton(key, label, active=false){
		const btn = document.createElement('button');
		btn.className = 'poi-cat-btn' + (active? ' active':'');
		btn.dataset.cat = key;
		btn.textContent = label;
		btn.addEventListener('click', () => {
			Array.from(categoriesContainer.children).forEach(b => b.classList.remove('active'));
			btn.classList.add('active');
			renderCategory(key);
		});
		return btn;
	}

	function renderButtons() {
		categoriesContainer.innerHTML = '';
		const keys = Object.keys(poiData);
		keys.forEach((k,i) => {
			const label = poiData[k].label || k;
			const btn = createButton(k, label, i===0);
			categoriesContainer.appendChild(btn);
		});
	}

	function renderCategory(cat) {
		if (!gallery) return;
		gallery.innerHTML = '';
		const items = (poiData[cat] && poiData[cat].images) || [];
		items.forEach(seed => {
			const card = document.createElement('div');
			card.className = 'poi-card';
			const img = document.createElement('img');
			img.src = `https://picsum.photos/seed/${encodeURIComponent(seed)}/800/600`;
			img.alt = `${poiData[cat]?.label || cat} image`;
			card.appendChild(img);
			gallery.appendChild(card);
		});
	}

	async function loadData(){
		try{
			const res = await fetch(window.location.pathname + 'data/');
			if(!res.ok) throw new Error('failed');
			poiData = await res.json();
		}catch(e){
			// fallback default
			const defaultCats = ['centrepoint','auditoriums','classrooms','itlabs','library','cafeteria'];
			poiData = {};
			defaultCats.forEach(k=>{poiData[k]={label:k.toUpperCase(),images:Array.from({length:8},(_,i)=>`${k}-${i+1}`)}});
		}
		renderButtons();
		const firstKey = Object.keys(poiData)[0];
		if(firstKey) renderCategory(firstKey);
		if(isAdmin) setupEditor();
	}

	// Admin editor logic
	function setupEditor(){
		const toggle = document.getElementById('poi-edit-toggle');
		const editorList = document.getElementById('poi-editor-list');
		const saveBtn = document.getElementById('poi-save');
		const cancelBtn = document.getElementById('poi-cancel');
		const addCatBtn = document.getElementById('add-category');

		function openEditor(){
			editor.setAttribute('aria-hidden','false');
			editor.style.display = 'block';
			populateEditorList();
		}
		function closeEditor(){
			editor.setAttribute('aria-hidden','true');
			editor.style.display = 'none';
		}

		toggle.addEventListener('click', openEditor);
		cancelBtn.addEventListener('click', closeEditor);

		function populateEditorList(){
			editorList.innerHTML = '';
			Object.keys(poiData).forEach(key=>{
				const block = document.createElement('div');
				block.className = 'poi-editor-item';
				// keep the original key for rename/save operations
				block.dataset.key = key;
				const title = document.createElement('input');
				title.value = poiData[key].label || key;
				title.className = 'poi-editor-item-label';
				const removeCat = document.createElement('button');
				removeCat.textContent = 'Remove Category';
				removeCat.addEventListener('click', ()=>{ delete poiData[key]; populateEditorList(); renderButtons(); renderCategory(Object.keys(poiData)[0]); });

				const imgsWrap = document.createElement('div');
				imgsWrap.className = 'poi-editor-images';
				(poiData[key].images||[]).forEach((seed,idx)=>{
					const row = document.createElement('div');
					row.className = 'poi-editor-image-row';
					// show thumbnail (if seed looks like a url use directly, otherwise use picsum seed)
					const thumb = document.createElement('img');
					thumb.className = 'poi-editor-thumb';
					if(/^https?:\/\//i.test(seed)) thumb.src = seed;
					else thumb.src = `https://picsum.photos/seed/${encodeURIComponent(seed)}/200/150`;
					thumb.alt = 'preview';
					thumb.style.maxWidth = '120px';
					thumb.style.borderRadius = '6px';

					const rem = document.createElement('button');
					rem.textContent = 'Remove';
					rem.addEventListener('click', ()=>{ poiData[key].images.splice(idx,1); populateEditorList(); });

					// file input to upload and replace this image
					const fileInput = document.createElement('input');
					fileInput.type = 'file';
					fileInput.accept = 'image/*';
					fileInput.className = 'poi-editor-image-file';
					fileInput.addEventListener('change', async ()=>{
						if(!fileInput.files || !fileInput.files[0]) return;
						const f = fileInput.files[0];
						const fd = new FormData();
						fd.append('file', f);
						try{
							const upl = await fetch(window.location.pathname + 'upload/', { method: 'POST', headers: { 'X-CSRFToken': csrfToken }, body: fd });
							const data = await upl.json();
							if(upl.ok && data.url){
								poiData[key].images[idx] = data.url;
								populateEditorList();
							} else {
								alert('Upload failed');
							}
						}catch(err){ alert('Upload error: ' + err.message); }
					});

					row.appendChild(thumb);
					row.appendChild(fileInput);
					row.appendChild(rem);
					imgsWrap.appendChild(row);
				});

				const addImgRow = document.createElement('div');
				addImgRow.className = 'poi-editor-add-image';
				const addFile = document.createElement('input');
				addFile.type = 'file';
				addFile.accept = 'image/*';
				addFile.addEventListener('change', async ()=>{
					if(!addFile.files || !addFile.files[0]) return;
					const f = addFile.files[0];
					const fd = new FormData();
					fd.append('file', f);
					try{
						const upl = await fetch(window.location.pathname + 'upload/', { method: 'POST', headers: { 'X-CSRFToken': csrfToken }, body: fd });
						const data = await upl.json();
						if(upl.ok && data.url){
							poiData[key].images = poiData[key].images || [];
							poiData[key].images.push(data.url);
							addFile.value = '';
							populateEditorList();
						} else {
							alert('Upload failed');
						}
					}catch(err){ alert('Upload error: ' + err.message); }
				});

		// allow adding an auto-generated seed image or uploading a file
		const addBtn = document.createElement('button');
		addBtn.textContent = 'Add Image';
		addBtn.addEventListener('click', ()=>{
			if(!poiData[key]) return;
			poiData[key].images = poiData[key].images || [];
			const seed = `${key}-${poiData[key].images.length+1}`;
			poiData[key].images.push(seed);
			populateEditorList();
		});

		addImgRow.appendChild(addBtn);
				block.appendChild(title);
				block.appendChild(removeCat);
				block.appendChild(imgsWrap);
				block.appendChild(addImgRow);
				editorList.appendChild(block);
			});
		}

		addCatBtn.addEventListener('click', ()=>{
			const newLabel = document.getElementById('new-cat-label').value.trim();
			if(!newLabel) return alert('Provide a category label');
			// generate key from label
			let baseKey = slugify(newLabel) || 'category';
			let key = baseKey;
			let i = 1;
			while(poiData[key]){ key = baseKey + '-' + i; i++; }
			poiData[key] = {label:newLabel, images: []};
			document.getElementById('new-cat-label').value='';
			populateEditorList(); renderButtons();
		});

		saveBtn.addEventListener('click', async ()=>{
			// Build new data object to safely handle renames
			const blocks = Array.from(document.querySelectorAll('.poi-editor-item'));
			const newData = {};
			const oldToNew = {};

			for(const block of blocks){
				const oldKey = block.dataset.key;
				const labelInput = block.querySelector('.poi-editor-item-label');
				const newLabel = (labelInput.value || '').trim() || oldKey;
				let newKeyBase = slugify(newLabel) || 'category';
				let newKey = newKeyBase;
				let idx = 1;
				// ensure uniqueness within newData
				while(newData[newKey]){ newKey = `${newKeyBase}-${idx}`; idx++; }
				oldToNew[oldKey] = newKey;
				newData[newKey] = { label: newLabel, images: Array.isArray(poiData[oldKey]?.images) ? poiData[oldKey].images.slice() : [] };
			}

			poiData = newData;

			try{
				const res = await fetch(window.location.pathname + 'save/', {
					method: 'POST',
					headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrfToken },
					body: JSON.stringify(poiData)
				});
				if(!res.ok) throw new Error('save failed');
				alert('Saved');
				// refresh UI to reflect new keys
				renderButtons();
				// try to preserve selection: if previously active, map to new key
				const prevActive = document.querySelector('.poi-cat-btn.active')?.dataset.cat;
				let newActive = Object.keys(poiData)[0];
				if(prevActive && oldToNew[prevActive]) newActive = oldToNew[prevActive];
				Array.from(categoriesContainer.children).forEach(b=>b.classList.remove('active'));
				const node = Array.from(categoriesContainer.children).find(b=>b.dataset.cat===newActive);
				if(node) node.classList.add('active');
				renderCategory(newActive);
				closeEditor();
			}catch(e){
				alert('Failed to save: ' + e.message);
			}
		});
	}

	loadData();
});
