const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// ── MIDDLEWARE ────────────────────────────────────────────────────────────────
app.use(cors());
app.use(express.json());
app.use(express.static('../frontend'));

// Rate limiting — max 100 requests per 15 minutes per IP
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

// ── START ─────────────────────────────────────────────────────────────────────
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
