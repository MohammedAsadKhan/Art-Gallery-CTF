const express = require('express');
const router = express.Router();
const pool = require('../db');

const BLOCKED = ['insert', 'update', 'delete', 'drop', 'alter', 'create', 'truncate', 'grant', 'revoke'];

router.post('/', async (req, res) => {
    const { query } = req.body;

    if (!query || typeof query !== 'string') {
        return res.status(400).json({ success: false, error: 'No query provided.' });
    }

    const lower = query.toLowerCase().trim();

    if (!lower.startsWith('select')) {
        return res.status(400).json({ success: false, error: 'Only SELECT queries are allowed.' });
    }

    for (const word of BLOCKED) {
        if (lower.includes(word)) {
            return res.status(400).json({ success: false, error: `Query contains forbidden keyword: ${word.toUpperCase()}` });
        }
    }

    if (query.length > 2000) {
        return res.status(400).json({ success: false, error: 'Query is too long. Max 2000 characters.' });
    }

    try {
        const start = Date.now();
        const result = await pool.query(query);
        const duration = Date.now() - start;

        res.json({
            success: true,
            rows: result.rows,
            rowCount: result.rowCount,
            fields: result.fields.map(f => f.name),
            executionTime: duration,
        });
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});

module.exports = router;
