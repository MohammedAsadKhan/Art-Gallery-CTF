const express = require('express');
const router = express.Router();
const pool = require('../db');

const ALLOWED_TABLES = [
    'artists',
    'artworks',
    'gallery_locations',
    'staff',
    'collectors',
    'exhibitions',
    'exhibition_artworks',
    'transactions',
    'authentications',
];

// Get list of all tables
router.get('/', (req, res) => {
    res.json({ success: true, tables: ALLOWED_TABLES });
});

// Get data from a specific table
router.get('/:tableName', async (req, res) => {
    const { tableName } = req.params;

    if (!ALLOWED_TABLES.includes(tableName)) {
        return res.status(400).json({ success: false, error: 'Invalid table name.' });
    }

    try {
        const result = await pool.query(`SELECT * FROM ${tableName} LIMIT 100`);
        res.json({
            success: true,
            table: tableName,
            rows: result.rows,
            rowCount: result.rowCount,
            fields: result.fields.map(f => f.name),
        });
    } catch (err) {
        res.status(500).json({ success: false, error: err.message });
    }
});

module.exports = router;
