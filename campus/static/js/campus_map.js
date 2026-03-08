(function(){
  const svg = document.getElementById('campusMap');
  const startSelect = document.getElementById('startSelect');
  const endSelect = document.getElementById('endSelect');
  const findBtn = document.getElementById('findPath');
  const poiList = document.getElementById('poiList');

  function fetchData(){
    return fetch(window.MAP_DATA_URL).then(r=>r.json());
  }

  function euclid(a,b){
    const dx = a.x - b.x; const dy = a.y - b.y; return Math.hypot(dx,dy);
  }

  function buildGraph(nodes, edges){
    const byId = new Map(nodes.map(n=>[n.id,n]));
    const adj = new Map();
    nodes.forEach(n=>adj.set(n.id, []));
    edges.forEach(e=>{
      const a = byId.get(e.from), b = byId.get(e.to);
      if(!a||!b) return;
      const w = euclid(a,b);
      adj.get(e.from).push({to:e.to, w});
      adj.get(e.to).push({to:e.from, w});
    });
    return {byId, adj};
  }

  function dijkstra(adj, start, goal){
    const dist = new Map();
    const prev = new Map();
    const Q = new Set();
    adj.forEach((_,k)=>{ dist.set(k, Infinity); Q.add(k); });
    dist.set(start, 0);
    while(Q.size){
      let u = null; let best = Infinity;
      Q.forEach(q=>{ if(dist.get(q) < best){ best = dist.get(q); u = q; } });
      if(u===null) break;
      Q.delete(u);
      if(u === goal) break;
      for(const edge of adj.get(u)){
        const alt = dist.get(u) + edge.w;
        if(alt < dist.get(edge.to)){
          dist.set(edge.to, alt);
          prev.set(edge.to, u);
        }
      }
    }
    const path = [];
    let u = goal;
    if(!prev.has(u) && u !== start) return null;
    while(u){ path.unshift(u); if(u === start) break; u = prev.get(u); }
    return path;
  }

  function clearSvg(){ while(svg.firstChild) svg.removeChild(svg.firstChild); }

  function drawEdges(nodes, edges){
    edges.forEach(e => {
      const a = nodes.find(n => n.id === e.from);
      const b = nodes.find(n => n.id === e.to);
      
      if (!a || !b) return;

      const line = document.createElementNS('http://www.w3.org/2000/svg', 'line');
      line.setAttribute('x1', a.x); line.setAttribute('y1', a.y);
      line.setAttribute('x2', b.x); line.setAttribute('y2', b.y);
      line.setAttribute('stroke', '#AAAAAA'); line.setAttribute('stroke-width', '3');
      svg.appendChild(line);
    });
  }

  function drawPath(nodes, path){
    if(path && path.length > 0){
      const points = path.map(id=>{ const n = nodes.find(x=>x.id===id); return n.x+","+n.y; }).join(' ');
      const poly = document.createElementNS('http://www.w3.org/2000/svg','polyline');
      poly.setAttribute('points', points); poly.setAttribute('fill','none');
      poly.setAttribute('stroke','#ff6f00'); poly.setAttribute('stroke-width','6'); poly.setAttribute('stroke-linecap','round');
      svg.appendChild(poly);
    }
  }

  function drawNodes(nodes, pathNodeIds){
    // Only draw nodes that are in the path and are terminals
    nodes.forEach(n=>{
      // Skip all pathway nodes
      if(n.type === 'pathway') return;
      
      // Only draw terminals that are in the path
      if(!pathNodeIds || !pathNodeIds.includes(n.id)) return;
      
      const g = document.createElementNS('http://www.w3.org/2000/svg','g');
      g.setAttribute('data-id', n.id);
      const c = document.createElementNS('http://www.w3.org/2000/svg','circle');
      c.setAttribute('cx', n.x); c.setAttribute('cy', n.y); c.setAttribute('r','8');
      c.setAttribute('fill','#2b7'); c.setAttribute('stroke','#064'); c.setAttribute('stroke-width','2');
      g.appendChild(c);
      const t = document.createElementNS('http://www.w3.org/2000/svg','text');
      t.setAttribute('x', n.x+12); t.setAttribute('y', n.y+4); t.setAttribute('font-size','12');
      t.setAttribute('font-weight','bold'); t.textContent = n.name || n.id;
      g.appendChild(t);
      svg.appendChild(g);
    });
  }

  function drawPOIs(nodes, pois, pathNodeIds){
    if(!Array.isArray(pois)) return;
    pois.forEach(p=>{
      const node = nodes.find(n=>n.id===p.node);
      if(!node) return;
      // Only show POIs on nodes that are in path or if no path yet
      if(pathNodeIds && !pathNodeIds.includes(p.node)) return;
      
      const g = document.createElementNS('http://www.w3.org/2000/svg','g');
      g.classList.add('poi'); g.setAttribute('data-poi', p.id);
      const rect = document.createElementNS('http://www.w3.org/2000/svg','rect');
      rect.setAttribute('x', node.x-10); rect.setAttribute('y', node.y-28); rect.setAttribute('width',20); rect.setAttribute('height',20);
      rect.setAttribute('rx',4); rect.setAttribute('fill','#ff6f00'); rect.setAttribute('opacity','0.95');
      g.appendChild(rect);
      const text = document.createElementNS('http://www.w3.org/2000/svg','text');
      text.setAttribute('x', node.x); text.setAttribute('y', node.y-14); text.setAttribute('text-anchor','middle'); text.setAttribute('font-size','11');
      text.setAttribute('fill','#fff'); text.textContent = p.name[0];
      g.appendChild(text);
      g.addEventListener('click', ()=>{
        alert(p.name + "\n" + p.description);
      });
      svg.appendChild(g);
    });
  }

  function draw(nodes, edges, pois, path){
    clearSvg();
    drawEdges(nodes, edges);
    
    const pathNodeIds = path ? path : null;
    drawPath(nodes, path);
    drawNodes(nodes, pathNodeIds);
  }

  function populateControls(nodes, pois){
    const poiItems = Array.isArray(pois) ? pois : [];
    startSelect.innerHTML = '';
    endSelect.innerHTML = '';
    const addOpt = (sel, value, label)=>{ const o = document.createElement('option'); o.value = value; o.textContent = label; sel.appendChild(o); };
    addOpt(startSelect,'','-- select start --'); 
    addOpt(endSelect,'','-- select end --');
    
    // Only add terminal nodes to dropdowns
    nodes.forEach(n => {
      if (n.type === 'terminal') {
        addOpt(startSelect, n.id, n.name || 'Node '+n.id);
        addOpt(endSelect, n.id, n.name || 'Node '+n.id);
      }
    });

    if(poiList) {
      poiList.innerHTML = '';
      poiItems.forEach(p=>{
        const d = document.createElement('div'); 
        d.className = 'poi-item'; 
        d.textContent = p.name + ' — ' + p.description; 
        d.addEventListener('click', ()=>{
          startSelect.value = p.node;
          alert('Selected: ' + p.name + '\nLocation: ' + p.node);
        }); 
        poiList.appendChild(d);
      });
    }
  }

  // Initialize
  fetchData().then(data=>{
    const {nodes = [], edges = [], pois = []} = data || {};
    const {byId, adj} = buildGraph(nodes, edges);
    populateControls(nodes, pois);
    
    // Initial draw with no path and no visible nodes
    draw(nodes, edges, pois, null);

    findBtn.addEventListener('click', ()=>{
      const s = startSelect.value; 
      const e = endSelect.value;
      if(!s || !e){ 
        alert('Please select both start and end locations'); 
        return; 
      }
      const path = dijkstra(adj, s, e);
      if(!path){ 
        alert('No path found between selected locations'); 
        return; 
      }
      // Redraw with path - nodes will only show on path
      draw(nodes, edges, pois, path);
    });

  }).catch(err=>{ console.error('map load failed', err); });
})();