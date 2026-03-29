document.addEventListener('DOMContentLoaded', function () {
	const categoriesContainer = document.getElementById('poi-categories');
	const gallery = document.getElementById('poi-gallery');
	const editor = document.getElementById('poi-editor');
	const lightbox = document.getElementById('poi-lightbox');
	const isAdmin = !!editor;

	const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content');

	let poiData = {};
	let currentLightboxIndex = 0;
	let currentLightboxCategory = null;

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

	function normalizeImageData(img){
		if(typeof img === 'string'){
			return { src: img, caption: '' };
		}
		return img;
	}

	function renderCategory(cat) {
		if (!gallery) return;
		gallery.innerHTML = '';
		const items = (poiData[cat] && poiData[cat].images) || [];
		items.forEach((img, idx) => {
			const imgData = normalizeImageData(img);
			const card = document.createElement('div');
			card.className = 'poi-card';
			card.dataset.category = cat;
			card.dataset.index = idx;
			
			const imgElement = document.createElement('img');
			imgElement.src = imgData.src;
			imgElement.alt = imgData.caption || `${poiData[cat]?.label || cat} image`;
			
			const caption = document.createElement('div');
			caption.className = 'poi-card-caption';
			caption.textContent = imgData.caption || 'Click to open';
			
			card.appendChild(imgElement);
			card.appendChild(caption);
			
			card.addEventListener('click', () => openLightbox(cat, idx));
			gallery.appendChild(card);
		});
	}

	function openLightbox(cat, idx){
		currentLightboxCategory = cat;
		currentLightboxIndex = idx;
		updateLightbox();
		lightbox.setAttribute('aria-hidden', 'false');
		document.body.style.overflow = 'hidden';
	}

	function closeLightbox(){
		lightbox.setAttribute('aria-hidden', 'true');
		document.body.style.overflow = 'auto';
	}

	function updateLightbox(){
		const items = (poiData[currentLightboxCategory]?.images) || [];
		if(items.length === 0) return;
		
		const imgData = normalizeImageData(items[currentLightboxIndex]);
		const lightboxImg = document.getElementById('poi-lightbox-img');
		const lightboxCaption = document.getElementById('poi-lightbox-caption');
		
		lightboxImg.src = imgData.src;
		lightboxCaption.textContent = imgData.caption || '(No caption)';
	}

	function nextLightboxImage(){
		const items = (poiData[currentLightboxCategory]?.images) || [];
		currentLightboxIndex = (currentLightboxIndex + 1) % items.length;
		updateLightbox();
	}

	function prevLightboxImage(){
		const items = (poiData[currentLightboxCategory]?.images) || [];
		currentLightboxIndex = (currentLightboxIndex - 1 + items.length) % items.length;
		updateLightbox();
	}

	if(lightbox){
		document.getElementById('poi-lightbox-close').addEventListener('click', closeLightbox);
		document.getElementById('poi-lightbox-next').addEventListener('click', nextLightboxImage);
		document.getElementById('poi-lightbox-prev').addEventListener('click', prevLightboxImage);
		lightbox.addEventListener('click', (e) => {
			if(e.target === lightbox) closeLightbox();
		});
		document.addEventListener('keydown', (e) => {
			if(lightbox.getAttribute('aria-hidden') === 'false'){
				if(e.key === 'Escape') closeLightbox();
				else if(e.key === 'ArrowRight') nextLightboxImage();
				else if(e.key === 'ArrowLeft') prevLightboxImage();
			}
		});
	}

	async function loadData(){
		try{
			const res = await fetch(window.location.pathname + 'data/');
			if(!res.ok) throw new Error('failed');
			poiData = await res.json();
		}catch(e){
			const defaultCats = ['centrepoint','auditoriums','classrooms','itlabs','library','cafeteria'];
			poiData = {};
			defaultCats.forEach(k=>{
				poiData[k]={
					label:k.toUpperCase(),
					images:Array.from({length:8},(_,i)=>({src:`${k}-${i+1}`, caption:''}))
				};
			});
		}
		renderButtons();
		const firstKey = Object.keys(poiData)[0];
		if(firstKey) renderCategory(firstKey);
		if(isAdmin) setupEditor();
	}

	function setupEditor(){
		const toggle = document.getElementById('poi-edit-toggle');
		const editorList = document.getElementById('poi-editor-list');
		const saveBtn = document.getElementById('poi-save');
		const cancelBtn = document.getElementById('poi-cancel');
		const addCatBtn = document.getElementById('add-category');

		async function openEditor(){
			try{
				const res = await fetch(window.location.pathname + 'data/');
				if(res.ok){
					poiData = await res.json();
				}
			}catch(e){
				console.error('Failed to reload data:', e);
			}
			editor.setAttribute('aria-hidden','false');
			editor.style.display = 'block';
			populateEditorList();
		}
		async function closeEditor(){
			try{
				const res = await fetch(window.location.pathname + 'data/');
				if(res.ok){
					poiData = await res.json();
				}
			}catch(e){
				console.error('Failed to reload data:', e);
			}
			editor.setAttribute('aria-hidden','true');
			editor.style.display = 'none';
			const firstKey = Object.keys(poiData)[0];
			if(firstKey) renderCategory(firstKey);
		}

		toggle.addEventListener('click', openEditor);
		cancelBtn.addEventListener('click', closeEditor);

		function populateEditorList(){
			editorList.innerHTML = '';
			Object.keys(poiData).forEach(key=>{
				const block = document.createElement('div');
				block.className = 'poi-editor-item';
				block.dataset.key = key;
				
				const title = document.createElement('input');
				title.value = poiData[key].label || key;
				title.className = 'poi-editor-item-label';
				title.placeholder = 'Category name';
				
				const removeCat = document.createElement('button');
				removeCat.textContent = 'Remove Category';
				removeCat.style.marginBottom = '8px';
				removeCat.addEventListener('click', ()=>{ delete poiData[key]; populateEditorList(); renderButtons(); renderCategory(Object.keys(poiData)[0]); });

				const imgsWrap = document.createElement('div');
				imgsWrap.className = 'poi-editor-images';
				(poiData[key].images||[]).forEach((img,idx)=>{
					const imgData = normalizeImageData(img);
					const row = document.createElement('div');
					row.className = 'poi-editor-image-row';

					const thumb = document.createElement('img');
					thumb.className = 'poi-editor-thumb';
					thumb.src = imgData.src;
					thumb.alt = 'preview';

					const controlsSection = document.createElement('div');
					controlsSection.className = 'poi-editor-controls-section';

					const captionLabel = document.createElement('label');
					captionLabel.className = 'poi-editor-field-label';
					captionLabel.textContent = 'Caption:';
					
					const captionInput = document.createElement('input');
					captionInput.type = 'text';
					captionInput.placeholder = 'Image description';
					captionInput.value = imgData.caption || '';
					captionInput.className = 'poi-editor-caption-input';

					const captionContainer = document.createElement('div');
					captionContainer.className = 'poi-editor-field-group';
					captionContainer.appendChild(captionLabel);
					captionContainer.appendChild(captionInput);

					const fileLabel = document.createElement('label');
					fileLabel.className = 'poi-editor-field-label';
					fileLabel.textContent = 'Replace image:';
					
					const fileInput = document.createElement('input');
					fileInput.type = 'file';
					fileInput.accept = 'image/*';
					fileInput.className = 'poi-editor-image-file';

					const fileContainer = document.createElement('div');
					fileContainer.className = 'poi-editor-field-group';
					fileContainer.appendChild(fileLabel);
					fileContainer.appendChild(fileInput);

					controlsSection.appendChild(captionContainer);
					controlsSection.appendChild(fileContainer);

					const rem = document.createElement('button');
					rem.className = 'poi-editor-remove-btn';

					const icon = document.createElement('img');
					icon.src = '/static/myapp/images/closeicon.png';
					icon.alt = 'Remove';
					icon.className = 'remove-icon';

					rem.appendChild(icon);
					rem.addEventListener('click', ()=>{ poiData[key].images.splice(idx,1); populateEditorList(); });

					fileInput.addEventListener('change', async ()=>{
						if(!fileInput.files || !fileInput.files[0]) return;
						const f = fileInput.files[0];
						const fd = new FormData();
						fd.append('file', f);
						try{
							const upl = await fetch(window.location.pathname + 'upload/', { method: 'POST', headers: { 'X-CSRFToken': csrfToken }, body: fd });
							const data = await upl.json();
							if(upl.ok && data.url){
								poiData[key].images[idx] = { src: data.url, caption: imgData.caption };
								populateEditorList();
							} else {
								showNotif('error', 'Upload failed');
							}
						}catch(err){ showNotif('error', 'Upload error: ' + err.message); }
					});

					captionInput.addEventListener('change', () => {
						if(poiData[key].images[idx]){
							if(typeof poiData[key].images[idx] === 'string'){
								poiData[key].images[idx] = { src: poiData[key].images[idx], caption: captionInput.value };
							} else {
								poiData[key].images[idx].caption = captionInput.value;
							}
						}
					});

					row.appendChild(thumb);
					row.appendChild(controlsSection);
					row.appendChild(rem);
					imgsWrap.appendChild(row);
				});

				const addImgRow = document.createElement('div');
				addImgRow.className = 'poi-editor-add-image';
				
				const addLabel = document.createElement('label');
				addLabel.className = 'poi-editor-add-image-label';
				addLabel.textContent = 'Upload new image:';
				
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
							poiData[key].images.push({ src: data.url, caption: '' });
							addFile.value = '';
							populateEditorList();
						} else {
							showNotif('error', 'Upload failed');
						}
					}catch(err){ showNotif('error', 'Upload error: ' + err.message); }
				});

				addImgRow.appendChild(addLabel);
				addImgRow.appendChild(addFile);
				block.appendChild(title);
				block.appendChild(removeCat);
				block.appendChild(imgsWrap);
				block.appendChild(addImgRow);
				editorList.appendChild(block);
			});
		}

		addCatBtn.addEventListener('click', ()=>{
			const newLabel = document.getElementById('new-cat-label').value.trim();
			if(!newLabel) return showNotif('warning', 'Provide a category label');
			let baseKey = slugify(newLabel) || 'category';
			let key = baseKey;
			let i = 1;
			while(poiData[key]){ key = baseKey + '-' + i; i++; }
			poiData[key] = {label:newLabel, images: []};
			document.getElementById('new-cat-label').value='';
			populateEditorList(); renderButtons();
		});

		saveBtn.addEventListener('click', async ()=>{
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
				while(newData[newKey]){ newKey = `${newKeyBase}-${idx}`; idx++; }
				oldToNew[oldKey] = newKey;
				
				const captionInputs = block.querySelectorAll('.poi-editor-caption-input');
				const images = Array.isArray(poiData[oldKey]?.images) ? poiData[oldKey].images.slice() : [];
				images.forEach((img, i) => {
					const normalized = normalizeImageData(img);
					if(captionInputs[i]){
						normalized.caption = captionInputs[i].value;
					}
					images[i] = normalized;
				});
				
				newData[newKey] = { label: newLabel, images: images };
			}

			poiData = newData;

			try{
				const res = await fetch(window.location.pathname + 'save/', {
					method: 'POST',
					headers: { 'Content-Type': 'application/json', 'X-CSRFToken': csrfToken },
					body: JSON.stringify(poiData)
				});
				if(!res.ok) throw new Error('save failed');
				showNotif('success', 'Saved');
				renderButtons();
				const prevActive = document.querySelector('.poi-cat-btn.active')?.dataset.cat;
				let newActive = Object.keys(poiData)[0];
				if(prevActive && oldToNew[prevActive]) newActive = oldToNew[prevActive];
				Array.from(categoriesContainer.children).forEach(b=>b.classList.remove('active'));
				const node = Array.from(categoriesContainer.children).find(b=>b.dataset.cat===newActive);
				if(node) node.classList.add('active');
				renderCategory(newActive);
				closeEditor();
			}catch(e){
				showNotif('error', 'Failed to save: ' + e.message);
			}
		});
	}

	loadData();
});
