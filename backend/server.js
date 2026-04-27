const express = require('express');
const cors = require('cors');
const path = require('path');
const rateLimit = require('express-rate-limit');
require('dotenv').config({ override: false });

const app = express();
const PORT = process.env.PORT || 3000;

// ── SERVE FRONTEND FIRST ──────────────────────────────────────────────────────
app.use(express.static(path.join(__dirname, 'public')));

const fs = require('fs');
app.get('/debug', (req, res) => {
    const cwd = process.cwd();
    const files = fs.readdirSync(cwd);
    res.json({ cwd, files });
});

// ── MIDDLEWARE ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());

// Rate limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000,
    max: 100,
    message: { success: false, error: 'Too many requests. Please slow down.' }
});
app.use('/api/', limiter);

// ── ROUTES ────────────────────────────────────────────────────────────────────
app.use('/api/query',  require('./routes/query'));
app.use('/api/tables', require('./routes/tables'));
app.use('/api/ctf',    require('./routes/ctf'));

// Health check
app.get('/api/health', (req, res) => {
    res.json({ success: true, message: 'DBMS Art Gallery API is running 🎨' });
});

// Fallback — serve index.html for any unknown route
app.get('/{*path}', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ── START ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});