// ── CONFIG ────────────────────────────────────────────────────────────────────
const API = 'https://art-gallery-ctf-production.up.railway.app/api';

// ── NAVIGATION ────────────────────────────────────────────────────────────────
function navigate(section) {
  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
  document.getElementById(section).classList.add('active');
  document.querySelector(`[data-section="${section}"]`).classList.add('active');
  window.scrollTo(0, 0);

  if (section === 'database' && !window.tablesLoaded) loadTableButtons();
  if (section === 'ctf' && !window.ctfLoaded) loadCTF();
}

document.querySelectorAll('.nav-link').forEach(link => {
  link.addEventListener('click', (e) => {
    e.preventDefault();
    navigate(link.dataset.section);
  });
});

// ── TERMINAL ANIMATION ────────────────────────────────────────────────────────
const terminalLines = [
  'Sunrise Over the Plaza',
  'Steel Lotus',
  'Skyline Series I',
];
let termIdx = 0;
let charIdx = 0;
let typingEl = document.getElementById('typingLine');
let isTyping = false;

function typeNext() {
  if (isTyping) return;
  isTyping = true;
  const line = terminalLines[termIdx];
  let out = '';
  charIdx = 0;

  const interval = setInterval(() => {
    if (charIdx < line.length) {
      out += line[charIdx];
      typingEl.innerHTML = `<span class="t-out"> "${out}"</span><span class="t-cursor">█</span>`;
      charIdx++;
    } else {
      clearInterval(interval);
      setTimeout(() => {
        termIdx = (termIdx + 1) % terminalLines.length;
        isTyping = false;
        typeNext();
      }, 1800);
    }
  }, 60);
}

setTimeout(typeNext, 1500);

// ── DATABASE BROWSER ──────────────────────────────────────────────────────────
const TABLES = ['artists','artworks','gallery_locations','staff','collectors','exhibitions','exhibition_artworks','transactions','authentications'];
window.tablesLoaded = false;

function loadTableButtons() {
  const container = document.getElementById('tableButtons');
  TABLES.forEach(t => {
    const btn = document.createElement('button');
    btn.className = 'ts-btn';
    btn.textContent = t;
    btn.onclick = () => loadTable(t, btn);
    container.appendChild(btn);
  });
  window.tablesLoaded = true;
}

async function loadTable(tableName, btn) {
  document.querySelectorAll('.ts-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');

  const output = document.getElementById('dbOutput');
  output.innerHTML = '<div class="loading">Loading</div>';

  try {
    const res = await fetch(`${API}/tables/${tableName}`);
    const data = await res.json();
    if (!data.success) throw new Error(data.error);
    renderTable(output, data.fields, data.rows, data.rowCount, tableName);
  } catch (err) {
    output.innerHTML = `<div class="error-msg">⚠ ${err.message}</div>`;
  }
}

function renderTable(container, fields, rows, rowCount, label = '') {
  if (!rows.length) {
    container.innerHTML = '<div class="db-placeholder"><span>No data found</span></div>';
    return;
  }

  const table = document.createElement('div');
  table.style.overflow = 'auto';

  let html = '<table class="data-table"><thead><tr>';
  fields.forEach(f => { html += `<th>${f.toUpperCase()}</th>`; });
  html += '</tr></thead><tbody>';

  rows.forEach(row => {
    html += '<tr>';
    fields.forEach(f => {
      const val = row[f] === null ? '<span style="color:var(--gray)">NULL</span>' : String(row[f]);
      html += `<td title="${String(row[f] ?? '')}">${val}</td>`;
    });
    html += '</tr>';
  });

  html += '</tbody></table>';
  html += `<div class="table-meta"><span>${label || 'result'}</span><span>${rowCount} row${rowCount !== 1 ? 's' : ''}</span></div>`;
  container.innerHTML = html;
}

// ── QUERY LAB ─────────────────────────────────────────────────────────────────
function clearQuery() {
  document.getElementById('queryInput').value = '';
  document.getElementById('queryResults').innerHTML = '<div class="db-placeholder"><span class="placeholder-icon">▶</span><span>Results will appear here after execution</span></div>';
}

function loadExample() {
  document.getElementById('queryInput').value =
    'SELECT ar.first_name || \' \' || ar.last_name AS artist,\n       COUNT(a.artwork_id) AS total_artworks,\n       SUM(a.estimated_value) AS total_value\nFROM artists ar\nJOIN artworks a ON ar.artist_id = a.artist_id\nGROUP BY ar.artist_id, ar.first_name, ar.last_name\nORDER BY total_value DESC;';
}

function setQuery(q) {
  document.getElementById('queryInput').value = q;
  navigate('querylab');
}

async function runQuery() {
  const query = document.getElementById('queryInput').value.trim();
  if (!query) return;

  const results = document.getElementById('queryResults');
  results.innerHTML = '<div class="loading">Executing</div>';

  try {
    const res = await fetch(`${API}/query`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query })
    });
    const data = await res.json();

    if (!data.success) {
      results.innerHTML = `<div class="error-msg">⚠ ${data.error}</div>`;
      return;
    }

    renderTable(results, data.fields, data.rows, data.rowCount);
    const meta = results.querySelector('.table-meta');
    if (meta) meta.innerHTML += `<span>⚡ ${data.executionTime}ms</span>`;

  } catch (err) {
    results.innerHTML = `<div class="error-msg">⚠ Connection error: ${err.message}</div>`;
  }
}

// Allow Ctrl+Enter to run query
document.addEventListener('keydown', (e) => {
  if (e.ctrlKey && e.key === 'Enter') runQuery();
});

// ── CTF ANSWERS ───────────────────────────────────────────────────────────────
const ANSWERS = {
  1: `SELECT a.title, au.result, au.notes\nFROM authentications au\nJOIN artworks a ON au.artwork_id = a.artwork_id\nWHERE au.result = 'Forgery';`,
  2: `SELECT c.name, c.reputation_score\nFROM collectors c\nWHERE c.collector_id IN (\n  SELECT buyer_id FROM transactions\n  WHERE artwork_id IN (\n    SELECT artwork_id FROM authentications\n    WHERE result = 'Forgery'\n  )\n);`,
  3: `SELECT title, estimated_value\nFROM artworks\nORDER BY estimated_value DESC\nLIMIT 1;`,
  4: `SELECT ar.first_name || ' ' || ar.last_name AS artist,\n       COUNT(a.artwork_id) AS total_artworks\nFROM artists ar\nJOIN artworks a ON ar.artist_id = a.artist_id\nGROUP BY ar.artist_id, ar.first_name, ar.last_name\nORDER BY total_artworks DESC\nLIMIT 1;`,
  5: `SELECT e.title, SUM(ea.insurance_value) AS total_insured\nFROM exhibitions e\nJOIN exhibition_artworks ea ON e.exhibition_id = ea.exhibition_id\nGROUP BY e.exhibition_id, e.title\nORDER BY total_insured DESC\nLIMIT 1;`,
};

// ── CTF ───────────────────────────────────────────────────────────────────────
window.ctfLoaded = false;
let solvedCount = 0;

async function loadCTF() {
  const grid = document.getElementById('ctfGrid');
  grid.innerHTML = '<div class="loading">Loading challenges</div>';

  try {
    const res = await fetch(`${API}/ctf`);
    const data = await res.json();
    if (!data.success) throw new Error(data.error);

    const saved = JSON.parse(localStorage.getItem('ctf_progress') || '{}');
    solvedCount = Object.values(saved).filter(Boolean).length;

    grid.innerHTML = '';
    data.challenges.forEach((c, i) => {
      const isSolved = saved[c.id] === true;
      const isLocked = i > 0 && !saved[data.challenges[i - 1].id];
      grid.appendChild(buildChallengeCard(c, isSolved, isLocked));
    });

    updateProgress();
    window.ctfLoaded = true;
  } catch (err) {
    grid.innerHTML = `<div class="error-msg">⚠ ${err.message}</div>`;
  }
}

function buildChallengeCard(challenge, isSolved, isLocked) {
  const card = document.createElement('div');
  card.className = `ctf-card ${isSolved ? 'solved' : ''} ${isLocked ? 'locked' : ''}`;
  card.id = `challenge-${challenge.id}`;

  const statusText = isSolved ? 'SOLVED' : isLocked ? 'LOCKED' : 'ACTIVE';
  const statusClass = isSolved ? 'solved' : isLocked ? 'locked' : 'active';

  const hintsHtml = challenge.hints.map(h => `<div class="hint-item">${h}</div>`).join('');

  card.innerHTML = `
    <div class="ctf-card-header" onclick="toggleCard(${challenge.id})">
      <div class="cch-left">
        <span class="cch-num">0${challenge.id}</span>
        <span class="cch-title">${challenge.title.toUpperCase()}</span>
      </div>
      <div style="display:flex;align-items:center;gap:1rem">
        <span class="cch-status ${statusClass}">${statusText}</span>
        <span class="cch-toggle" id="toggle-${challenge.id}">▼</span>
      </div>
    </div>
    <div class="ctf-card-body ${challenge.id === 1 && !isSolved ? 'open' : ''}" id="body-${challenge.id}">
      <div class="ctf-scenario">${challenge.scenario}</div>
      <div class="ctf-hints">
        <button class="hints-toggle" onclick="toggleHints(${challenge.id})">💡 Show Hints</button>
        <div class="hints-list" id="hints-${challenge.id}">${hintsHtml}</div>
      </div>
      <textarea class="ctf-editor" id="editor-${challenge.id}" placeholder="-- Write your SQL query here\nSELECT ..."></textarea>
      <div class="ctf-submit-row">
        <button class="btn-primary" onclick="submitChallenge(${challenge.id})">▶ SUBMIT QUERY</button>
        <button class="btn-reveal" onclick="toggleAnswer(${challenge.id})">👁 REVEAL ANSWER</button>
        <div class="ctf-feedback" id="feedback-${challenge.id}"></div>
      </div>
      <div class="answer-box" id="answer-${challenge.id}">
        <div class="answer-label">// SOLUTION</div>
        <pre class="answer-code">${ANSWERS[challenge.id]}</pre>
        <button class="answer-use-btn" onclick="useAnswer(${challenge.id})">USE THIS QUERY →</button>
      </div>
      <div class="ctf-results" id="ctf-results-${challenge.id}"></div>
    </div>
  `;

  if (isSolved) {
    const fb = card.querySelector(`#feedback-${challenge.id}`);
    fb.className = 'ctf-feedback correct';
    fb.textContent = '✓ Challenge solved!';
  }

  return card;
}

function toggleAnswer(id) {
  const box = document.getElementById(`answer-${id}`);
  box.classList.toggle('open');
}

function useAnswer(id) {
  const editor = document.getElementById(`editor-${id}`);
  editor.value = ANSWERS[id];
  document.getElementById(`answer-${id}`).classList.remove('open');
}

function toggleCard(id) {
  const body = document.getElementById(`body-${id}`);
  const toggle = document.getElementById(`toggle-${id}`);
  body.classList.toggle('open');
  toggle.textContent = body.classList.contains('open') ? '▲' : '▼';
}

function toggleHints(id) {
  const hints = document.getElementById(`hints-${id}`);
  hints.classList.toggle('open');
}

async function submitChallenge(id) {
  const query = document.getElementById(`editor-${id}`).value.trim();
  const feedback = document.getElementById(`feedback-${id}`);
  const resultsEl = document.getElementById(`ctf-results-${id}`);

  if (!query) { feedback.textContent = 'Please enter a query.'; return; }

  feedback.className = 'ctf-feedback';
  feedback.textContent = 'Running...';
  resultsEl.innerHTML = '';

  try {
    const res = await fetch(`${API}/ctf/${id}/submit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query })
    });
    const data = await res.json();

    if (!data.success) {
      feedback.className = 'ctf-feedback wrong';
      feedback.textContent = `⚠ ${data.error}`;
      return;
    }

    // Show results
    if (data.rows && data.rows.length > 0) {
      renderTable(resultsEl, data.fields, data.rows, data.rowCount);
    }

    if (data.correct) {
      feedback.className = 'ctf-feedback correct';
      feedback.textContent = data.message;

      // Save progress
      const saved = JSON.parse(localStorage.getItem('ctf_progress') || '{}');
      saved[id] = true;
      localStorage.setItem('ctf_progress', JSON.stringify(saved));

      // Mark card as solved
      const card = document.getElementById(`challenge-${id}`);
      card.classList.add('solved');
      card.querySelector('.cch-status').textContent = 'SOLVED';
      card.querySelector('.cch-status').className = 'cch-status solved';

      // Unlock next
      const nextCard = document.getElementById(`challenge-${id + 1}`);
      if (nextCard) {
        nextCard.classList.remove('locked');
        nextCard.querySelector('.cch-status').textContent = 'ACTIVE';
        nextCard.querySelector('.cch-status').className = 'cch-status active';
      }

      solvedCount++;
      updateProgress();
    } else {
      feedback.className = 'ctf-feedback wrong';
      feedback.textContent = data.message;
    }
  } catch (err) {
    feedback.className = 'ctf-feedback wrong';
    feedback.textContent = `⚠ ${err.message}`;
  }
}

function updateProgress() {
  const fill = document.getElementById('progressFill');
  const text = document.getElementById('progressText');
  const pct = (solvedCount / 5) * 100;
  fill.style.width = `${pct}%`;
  text.textContent = `${solvedCount} / 5`;
}
