const express = require('express');
const router = express.Router();
const pool = require('../db');

// ── CHALLENGE DEFINITIONS ────────────────────────────────────────────────────
const CHALLENGES = [
    {
        id: 1,
        title: "The Forgery",
        scenario: "A forgery has been detected in the gallery. Find the title of the artwork that was flagged as a forgery in the authentications table.",
        hints: [
            "Look at the authentications table",
            "You need to JOIN authentications with artworks",
            "Filter where result = 'Forgery'",
        ],
        // Validate by checking if the result contains the correct artwork title
        validate: async (rows) => {
            if (!rows || rows.length === 0) return false;
            const titles = rows.map(r => Object.values(r).join(' ').toLowerCase());
            return titles.some(t => t.includes('white square study'));
        }
    },
    {
        id: 2,
        title: "The Suspect",
        scenario: "Someone bought the forgery. Find the name of the collector who purchased the artwork flagged as a forgery.",
        hints: [
            "You need authentications, transactions, and collectors tables",
            "First find the forged artwork_id, then find who bought it",
            "Use a subquery or multiple JOINs",
        ],
        validate: async (rows) => {
            if (!rows || rows.length === 0) return false;
            const values = rows.map(r => Object.values(r).join(' ').toLowerCase());
            return values.some(v => v.includes('raymond cross'));
        }
    },
    {
        id: 3,
        title: "The Most Valuable",
        scenario: "The gallery wants to insure its most valuable artwork. Find the title and estimated value of the single most expensive artwork in the collection.",
        hints: [
            "Look at the artworks table",
            "Use ORDER BY estimated_value DESC",
            "Use LIMIT 1 to get only the top result",
        ],
        validate: async (rows) => {
            if (!rows || rows.length === 0) return false;
            const values = rows.map(r => Object.values(r).join(' ').toLowerCase());
            return values.some(v => v.includes('steel lotus'));
        }
    },
    {
        id: 4,
        title: "The Prolific Artist",
        scenario: "The gallery wants to feature their most productive artist. Find the artist who has the most artworks in the collection. Return their full name and artwork count.",
        hints: [
            "JOIN artists and artworks tables",
            "Use GROUP BY on the artist",
            "Use COUNT() and ORDER BY DESC with LIMIT 1",
        ],
        validate: async (rows) => {
            if (!rows || rows.length === 0) return false;
            const values = rows.map(r => Object.values(r).join(' ').toLowerCase());
            return values.some(v => v.includes('vasquez') || v.includes('elena') || v.includes('whitfield') || v.includes('monroe'));
        }
    },
    {
        id: 5,
        title: "The Hidden Exhibition",
        scenario: "Find which exhibition has the highest total insured value across all its displayed artworks. Return the exhibition title and the total insured value.",
        hints: [
            "Look at the exhibition_artworks table",
            "JOIN with exhibitions table",
            "Use SUM(insurance_value) and GROUP BY",
            "ORDER BY the sum DESC and LIMIT 1",
        ],
        validate: async (rows) => {
            if (!rows || rows.length === 0) return false;
            const values = rows.map(r => Object.values(r).join(' ').toLowerCase());
            return values.some(v => v.includes('steel and sky') || v.includes('210000'));
        }
    },
];

// Get all challenge info (no answers)
router.get('/', (req, res) => {
    const safe = CHALLENGES.map(({ id, title, scenario, hints }) => ({
        id, title, scenario, hints
    }));
    res.json({ success: true, challenges: safe });
});

// Submit a query for a challenge
router.post('/:id/submit', async (req, res) => {
    const challengeId = parseInt(req.params.id);
    const { query } = req.body;

    const challenge = CHALLENGES.find(c => c.id === challengeId);
    if (!challenge) {
        return res.status(404).json({ success: false, error: 'Challenge not found.' });
    }

    if (!query || typeof query !== 'string') {
        return res.status(400).json({ success: false, error: 'No query provided.' });
    }

    const lower = query.toLowerCase().trim();
    if (!lower.startsWith('select')) {
        return res.status(400).json({ success: false, error: 'Only SELECT queries are allowed.' });
    }

    try {
        const start = Date.now();
        const result = await pool.query(query);
        const duration = Date.now() - start;

        const isCorrect = await challenge.validate(result.rows);

        res.json({
            success: true,
            rows: result.rows,
            rowCount: result.rowCount,
            fields: result.fields.map(f => f.name),
            executionTime: duration,
            correct: isCorrect,
            message: isCorrect
                ? `🎉 Challenge ${challengeId} solved! Well done.`
                : '❌ Not quite right. Check your query and try again.',
        });
    } catch (err) {
        res.status(400).json({ success: false, error: err.message });
    }
});

module.exports = router;
