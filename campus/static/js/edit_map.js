(function(){
  const svg = document.getElementById('editMap');
  const addTerminalBtn = document.getElementById('addTerminal');
  const addPathBtn = document.getElementById('addPath');
  const addEdgeBtn = document.getElementById('addEdge');
  const deleteElementBtn = document.getElementById('deleteElement');
  const saveMapBtn = document.getElementById('saveMap');
  
  const SVG_NS = 'http://www.w3.org/2000/svg';
  const TERMINAL_RADIUS = 12;
  const PATHWAY_RADIUS = 8;
  
  let mapData = { nodes: [], edges: [] };
  let nextNodeId = 1;
  let mode = null;
  let selectedNode = null;
  let draggedNode = null;
  let dragOffset = { x: 0, y: 0 };

  function fetchMapData() {
    return fetch(window.MAP_DATA_URL).then(r => r.json());
  }

  async function init() {
    mapData = await fetchMapData();
    if (!mapData.nodes) mapData.nodes = [];
    if (!mapData.edges) mapData.edges = [];

    mapData.nodes = mapData.nodes.map(n => ({
      node_id: n.node_id || n.id,
      name: n.name,
      node_type: n.node_type || n.type,
      x: n.x,
      y: n.y
    }));

    mapData.edges = mapData.edges.map(e => ({
      from: e.from,
      to: e.to
    }));

    if (mapData.nodes.length > 0) {
      const numericIds = mapData.nodes
        .filter(n => n.node_id.match(/^N\d+$/))
        .map(n => parseInt(n.node_id.substring(1)))
        .sort((a, b) => b - a);
      nextNodeId = (numericIds.length > 0 ? numericIds[0] + 1 : 1);
    }
    
    renderMap();
    setupEventListeners();
  }
  
  function setupEventListeners() {
    addTerminalBtn.addEventListener('click', toggleAddTerminalMode);
    addPathBtn.addEventListener('click', toggleAddPathMode);
    addEdgeBtn.addEventListener('click', toggleAddEdgeMode);
    deleteElementBtn.addEventListener('click', toggleDeleteMode);
    saveMapBtn.addEventListener('click', saveMap);
    
    svg.addEventListener('click', handleSvgClick);
    svg.addEventListener('mousemove', handleMouseMove);
    svg.addEventListener('mouseup', handleMouseUp);
    svg.addEventListener('mouseleave', handleMouseLeave);
    svg.addEventListener('dblclick', (e) => e.preventDefault());
    svg.addEventListener('mousedown', (e) => {
      if (e.detail > 1) e.preventDefault();
    });
  }
  
  function toggleAddTerminalMode() {
    if (mode === 'add-terminal') {
      mode = null;
    } else {
      mode = 'add-terminal';
    }

    if (mode !== 'add-path') addPathBtn.textContent = 'Add Pathway';
    selectedNode = null;
    updateButtonStates();
    if (mode === 'add-terminal') {
      addTerminalBtn.textContent = 'Add Terminal (Click on map)';
    } else {
      addTerminalBtn.textContent = 'Add Terminal';
    }
  }

  function toggleAddPathMode() {
    if (mode === 'add-path') {
      mode = null;
    } else {
      mode = 'add-path';
    }
    if (mode !== 'add-terminal') addTerminalBtn.textContent = 'Add Terminal';
    selectedNode = null;
    updateButtonStates();
    if (mode === 'add-path') {
      addPathBtn.textContent = 'Add Pathway (Click on map)';
    } else {
      addPathBtn.textContent = 'Add Pathway';
    }
  }
  
  function toggleAddEdgeMode() {
    mode = mode === 'add-edge' ? null : 'add-edge';
    updateButtonStates();
    selectedNode = null;
    if (mode === 'add-edge') {
      addEdgeBtn.textContent = 'Add Edge (Click two nodes)';
    } else {
      addEdgeBtn.textContent = 'Add Edge';
    }
  }
  
  function toggleDeleteMode() {
    mode = mode === 'delete' ? null : 'delete';
    updateButtonStates();
    if (mode === 'delete') {
      deleteElementBtn.textContent = 'Delete Element (Click element)';
    } else {
      deleteElementBtn.textContent = 'Delete Element';
    }
  }
  
  function updateButtonStates() {
    addTerminalBtn.classList.toggle('active', mode === 'add-terminal');
    addPathBtn.classList.toggle('active', mode === 'add-path');
    addEdgeBtn.classList.toggle('active', mode === 'add-edge');
    deleteElementBtn.classList.toggle('active', mode === 'delete');
  }
  
  function handleSvgClick(e) {
    if (!mode) return;
    
    const rect = svg.getBoundingClientRect();
    const x = (e.clientX - rect.left) * (800 / rect.width);
    const y = (e.clientY - rect.top) * (600 / rect.height);
    
    if (mode === 'add-terminal') {
      addNode(x, y, 'terminal');
    } else if (mode === 'add-path') {
      addNode(x, y, 'pathway');
    } else if (mode === 'add-edge') {
      handleEdgeClick(e, x, y);
    } else if (mode === 'delete') {
      deleteAtPoint(x, y);
    }
  }
  
  function handleEdgeClick(e, x, y) {
    const clickedNode = findNodeAt(x, y);
    if (!clickedNode) return;
    
    if (!selectedNode) 
      {
      selectedNode = clickedNode;
      document.getElementById('node-' + clickedNode.node_id).style.stroke = 'orange';
      document.getElementById('node-' + clickedNode.node_id).style.strokeWidth = '3';
    } 
    
    else if (selectedNode.node_id === clickedNode.node_id) {
      document.getElementById('node-' + selectedNode.node_id).style.stroke = getNodeStrokeColor(selectedNode);
      document.getElementById('node-' + selectedNode.node_id).style.strokeWidth = '2';
      selectedNode = null;
    } 

    else {
      addEdge(selectedNode.node_id, clickedNode.node_id);
      document.getElementById('node-' + selectedNode.node_id).style.stroke = getNodeStrokeColor(selectedNode);
      document.getElementById('node-' + selectedNode.node_id).style.strokeWidth = '2';
      selectedNode = null;
    }
  }
  
  function addNode(x, y, type) {
    const nextId = 'N' + nextNodeId;
    nextNodeId++;
    
    const nodeType = type || 'terminal';
    const defaultName = nodeType === 'terminal' ? `Terminal ${nextId}` : '';
    const node = {
      node_id: nextId,
      name: defaultName,
      node_type: nodeType,
      x: Math.round(x),
      y: Math.round(y)
    };
    
    mapData.nodes.push(node);
    renderMap();
    showMessage(`Added ${nodeType} ${nextId}`);
  }
  
  function addEdge(fromId, toId) {
    const exists = mapData.edges.some(e => 
      (e.from === fromId && e.to === toId) ||
      (e.from === toId && e.to === fromId)
    );
    
    if (exists) {
      showMessage('Edge already exists!');
      return;
    }
    
    mapData.edges.push({
      from: fromId,
      to: toId
    });
    
    renderMap();
    showMessage(`Added edge from ${fromId} to ${toId}`);
  }
  
  function findNodeAt(x, y) {
    for (let node of mapData.nodes) {
      const radius = node.node_type === 'terminal' ? TERMINAL_RADIUS : PATHWAY_RADIUS;
      const dx = node.x - x;
      const dy = node.y - y;
      const dist = Math.hypot(dx, dy);
      if (dist <= radius + 5) {
        return node;
      }
    }
    return null;
  }
  
  function deleteAtPoint(x, y) {
    const node = findNodeAt(x, y);
    if (node) {
      deleteNode(node.node_id);
      return;
    }

    const edge = findEdgeAt(x, y);
    if (edge) {
      deleteEdge(edge);
      return;
    }
  }
  
  function findEdgeAt(x, y) {
    const threshold = 5;
    
    for (let edge of mapData.edges) {
      const fromNode = mapData.nodes.find(n => n.node_id === edge.from);
      const toNode = mapData.nodes.find(n => n.node_id === edge.to);
      
      if (!fromNode || !toNode) continue;

      const x1 = fromNode.x, y1 = fromNode.y;
      const x2 = toNode.x, y2 = toNode.y;

      const dist = pointToLineDistance(x, y, x1, y1, x2, y2);
      
      if (dist <= threshold) {
        return edge;
      }
    }
    
    return null;
  }
  
  function pointToLineDistance(px, py, x1, y1, x2, y2) {
    const dx = x2 - x1;
    const dy = y2 - y1;
    const t = Math.max(0, Math.min(1, ((px - x1) * dx + (py - y1) * dy) / (dx * dx + dy * dy)));
    const closest_x = x1 + t * dx;
    const closest_y = y1 + t * dy;
    return Math.hypot(px - closest_x, py - closest_y);
  }
  
  function deleteNode(nodeId) {
    mapData.nodes = mapData.nodes.filter(n => n.node_id !== nodeId);
    mapData.edges = mapData.edges.filter(e => e.from !== nodeId && e.to !== nodeId);
    renderMap();
    showMessage(`Deleted node ${nodeId}`);
  }
  
  function deleteEdge(edge) {
    mapData.edges = mapData.edges.filter(e => 
      !(e.from === edge.from && e.to === edge.to)
    );
    renderMap();
    showMessage(`Deleted edge`);
  }
  
  function handleMouseMove(e) {
    if (draggedNode) {
      const rect = svg.getBoundingClientRect();
      const x = (e.clientX - rect.left) * (800 / rect.width);
      const y = (e.clientY - rect.top) * (600 / rect.height);
      
      draggedNode.x = Math.round(x - dragOffset.x);
      draggedNode.y = Math.round(y - dragOffset.y);
      
      renderMap();
    }
  }
  
  function handleMouseUp(e) {
    draggedNode = null;
  }
  
  function handleMouseLeave(e) {
    draggedNode = null;
  }
  
  function renderMap() {
    svg.innerHTML = '';

    for (let edge of mapData.edges) {
      const fromNode = mapData.nodes.find(n => n.node_id === edge.from);
      const toNode = mapData.nodes.find(n => n.node_id === edge.to);
      
      if (fromNode && toNode) {
        const line = document.createElementNS(SVG_NS, 'line');
        line.setAttribute('x1', fromNode.x);
        line.setAttribute('y1', fromNode.y);
        line.setAttribute('x2', toNode.x);
        line.setAttribute('y2', toNode.y);
        line.setAttribute('stroke', '#666');
        line.setAttribute('stroke-width', '2');
        line.setAttribute('class', 'edge');
        line.setAttribute('data-from', edge.from);
        line.setAttribute('data-to', edge.to);
        line.style.cursor = 'pointer';
        
        svg.appendChild(line);
      }
    }

    for (let node of mapData.nodes) {
      const circle = document.createElementNS(SVG_NS, 'circle');
      circle.setAttribute('id', 'node-' + node.node_id);
      circle.setAttribute('cx', node.x);
      circle.setAttribute('cy', node.y);
      circle.setAttribute('fill', getNodeFillColor(node));
      circle.setAttribute('stroke', getNodeStrokeColor(node));
      circle.setAttribute('stroke-width', '2');
      circle.setAttribute('data-node-id', node.node_id);
      
      const radius = node.node_type === 'terminal' ? TERMINAL_RADIUS : PATHWAY_RADIUS;
      circle.setAttribute('r', radius);
      circle.style.cursor = 'move';

      circle.addEventListener('mousedown', (e) => {
        e.stopPropagation();
        if (mode !== 'add-edge' && mode !== 'add-terminal' && mode !== 'add-path' && mode !== 'delete') {
          draggedNode = node;
          const rect = svg.getBoundingClientRect();
          const mouseX = (e.clientX - rect.left) * (800 / rect.width);
          const mouseY = (e.clientY - rect.top) * (600 / rect.height);
          dragOffset.x = mouseX - node.x;
          dragOffset.y = mouseY - node.y;
        }
      });

      circle.addEventListener('dblclick', (e) => {
        e.preventDefault();
        e.stopPropagation();
        if (node.node_type === 'terminal') {
          const newName = prompt('Enter name for terminal', node.name || node.node_id);
          if (newName) {
            node.name = newName;
            renderMap();
          }
        }
      });
      
      svg.appendChild(circle);

      const text = document.createElementNS(SVG_NS, 'text');
      text.setAttribute('x', node.x);
      text.setAttribute('y', node.y - (node.node_type === 'terminal' ? 20 : 15));
      text.setAttribute('text-anchor', 'middle');
      text.setAttribute('font-size', '12');
      text.setAttribute('fill', '#333');
      text.setAttribute('pointer-events', 'none');
      text.textContent = node.name || node.node_id;
      svg.appendChild(text);
    }
  }
  
  function getNodeFillColor(node) {
    return node.node_type === 'terminal' ? '#4CAF50' : '#FFC107';
  }
  
  function getNodeStrokeColor(node) {
    return node.node_type === 'terminal' ? '#388E3C' : '#FFA000';
  }
  
  function saveMap() {
    const nodesToSave = mapData.nodes.map(n => ({
      node_id: n.node_id,
      name: n.name || (n.node_type === 'terminal' ? `Terminal ${n.node_id}` : `Pathway ${n.node_id}`),
      node_type: n.node_type,
      x: n.x,
      y: n.y
    }));
    
    const edgesToSave = mapData.edges;
    
    const payload = {
      nodes: nodesToSave,
      edges: edgesToSave
    };

    if (pendingImageData) {
      payload.image_data = pendingImageData;
    }

    fetch('/save-map/', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRFToken': getCookie('csrftoken')
      },
      body: JSON.stringify(payload)
    })
    .then(r => {
      if (!r.ok) throw new Error('Save failed');
      return r.json();
    })
    .then(data => {
      showMessage(data.message || 'Map saved successfully!', 'success');
      pendingImageData = null;
      setTimeout(() => {
        window.location.href = '/navigation/';
      }, 1500);
    })
    .catch(err => {
      showMessage('Error saving map: ' + err.message, 'error');
    });
  }
  
  function showMessage(msg, type = 'info') {
    let msgDiv = document.getElementById('message-box');
    if (!msgDiv) {
      msgDiv = document.createElement('div');
      msgDiv.id = 'message-box';
      msgDiv.style.cssText = 'position: fixed; top: 20px; right: 20px; padding: 15px; border-radius: 4px; color: white; background: #2196F3; z-index: 1000;';
      document.body.appendChild(msgDiv);
    }
    
    msgDiv.textContent = msg;
    if (type === 'error') msgDiv.style.background = '#F44336';
    if (type === 'success') msgDiv.style.background = '#4CAF50';
    msgDiv.style.display = 'block';
    
    setTimeout(() => {
      msgDiv.style.display = 'none';
    }, 3000);
  }
  
  function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
      const cookies = document.cookie.split(';');
      for (let i = 0; i < cookies.length; i++) {
        const cookie = cookies[i].trim();
        if (cookie.substring(0, name.length + 1) === (name + '=')) {
          cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
          break;
        }
      }
    }
    return cookieValue;
  }

  let cropper = null;
  let pendingImageData = null;
  
  function setupImageUpload() {
    const uploadBtn = document.getElementById('uploadMapBtn');
    const cropModal = document.getElementById('cropModal');
    const closeCropModal = document.getElementById('closeCropModal');
    const selectImageBtn = document.getElementById('selectImageBtn');
    const mapImageInput = document.getElementById('mapImageInput');
    const cropPreviewSection = document.getElementById('cropPreviewSection');
    const cropImage = document.getElementById('cropImage');
    const applyCropBtn = document.getElementById('applyCropBtn');
    const cancelCropBtn = document.getElementById('cancelCropBtn');

    uploadBtn?.addEventListener('click', () => {
      cropModal.style.display = 'flex';
      cropPreviewSection.style.display = 'none';
      if (cropper) {
        cropper.destroy();
        cropper = null;
      }
    });

    const closeModal = () => {
      cropModal.style.display = 'none';
      if (cropper) {
        cropper.destroy();
        cropper = null;
      }
      cropImage.src = '';
      mapImageInput.value = '';
      cropPreviewSection.style.display = 'none';
    };
    
    closeCropModal?.addEventListener('click', closeModal);
    cancelCropBtn?.addEventListener('click', closeModal);

    selectImageBtn?.addEventListener('click', () => {
      mapImageInput.click();
    });

    mapImageInput?.addEventListener('change', (e) => {
      const file = e.target.files[0];
      if (!file) return;
      
      if (!file.type.startsWith('image/')) {
        showMessage('Please select a valid image file', 'error');
        return;
      }
      
      const reader = new FileReader();
      reader.onload = (event) => {
        cropImage.src = event.target.result;
        cropPreviewSection.style.display = 'block';

        if (cropper) {
          cropper.destroy();
        }
        
        cropper = new Cropper(cropImage, {
          aspectRatio: 800 / 600,
          viewMode: 1,
          dragMode: 'move',
          autoCropArea: 1,
          restore: false,
          guides: true,
          center: true,
          highlight: false,
          cropBoxMovable: true,
          cropBoxResizable: true,
          toggleDragModeOnDblclick: false,
        });
      };
      
      reader.readAsDataURL(file);
    });

    applyCropBtn?.addEventListener('click', async () => {
      if (!cropper) {
        showMessage('No image selected', 'error');
        return;
      }
      
      applyCropBtn.disabled = true;
      applyCropBtn.textContent = '⏳ Processing...';
      
      try {
        const canvas = cropper.getCroppedCanvas({
          width: 800,
          height: 600,
          imageSmoothingEnabled: true,
          imageSmoothingQuality: 'high',
        });

        pendingImageData = canvas.toDataURL('image/png');

        const mapImage = document.getElementById('campusMapImage');
        if (mapImage) {
          mapImage.src = pendingImageData;
        }
        
        showMessage('Image ready! Click "Save Map" to apply changes.', 'success');
        closeModal();
        
      } catch (error) {
        console.error('Crop error:', error);
        showMessage('Failed to crop image: ' + error.message, 'error');
      } finally {
        applyCropBtn.disabled = false;
        applyCropBtn.textContent = '✓ Apply Cropped Image';
      }
    });
  }

  setupImageUpload();
  init();
})();