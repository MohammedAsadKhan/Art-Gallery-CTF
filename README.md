# Dallas Art Gallery Management System
### COSC 3336 — Database Management Systems | Spring 2026
**Team MAC** — Mohammed Asad Khan, Ashton Baker, Christina LaCombe  
**Texas A&M University – Corpus Christi**

---

## Project Overview

The Dallas Art Gallery Management System is a fully normalized relational database built in PostgreSQL, paired with an interactive web interface featuring a Capture-The-Flag (CTF) challenge component. The project demonstrates advanced database design, SQL query proficiency, and full-stack web development.

The system manages all aspects of an art gallery's operations — artwork inventory, artist records, staff assignments, exhibitions, collector transactions, and artwork authentications — while providing an engaging platform for users to explore the database through live SQL queries and mystery-solving challenges.

---

## Features

- **Database Browser** — Browse all 9 tables live from PostgreSQL
- **Query Lab** — Run any SELECT query against the live database and see results instantly
- **CTF Challenges** — 5 progressive SQL mystery challenges with hints and answer reveal
- **Dark Cyber Theme** — Custom-built UI with Orbitron font, gold accents, and terminal animations

---

## Database Schema

The database contains 9 tables normalized to Third Normal Form (3NF):

| Table | Description | Records |
|-------|-------------|---------|
| `artists` | Artist biographical and style information | 10 |
| `artworks` | Core artwork catalog | 50 |
| `gallery_locations` | Physical gallery branches | 5 |
| `staff` | Gallery employees and roles | 8 |
| `collectors` | Buyers, donors, and institutions | 7 |
| `exhibitions` | Themed shows at gallery locations | 5 |
| `exhibition_artworks` | Junction table (M:N resolver) | 10 |
| `transactions` | Sales, loans, and donations | 8 |
| `authentications` | Appraisal and forgery records | 7 |

### Key Relationships
- One artist creates many artworks (1:M)
- One location houses many artworks (1:M)
- One location employs many staff (1:M)
- One curator manages many exhibitions (1:M)
- Exhibitions display multiple artworks (M:N — resolved via `exhibition_artworks`)
- One artwork can have many authentications (1:M)
- One collector participates in many transactions (1:M)

### Constraints
- `security_level` CHECK (1–5) on `gallery_locations`
- `clearance_level` CHECK (1–5) on `staff`
- `reputation_score` CHECK (1–100) on `collectors`
- NOT NULL on all primary name and date fields
- Foreign key constraints enforcing all relationships

---

## CTF Challenges

Five progressive SQL mystery challenges are embedded in the database:

1. **The Forgery** — Find the artwork flagged as a forgery in the authentications table
2. **The Suspect** — Identify the collector who purchased the forged artwork
3. **The Most Valuable** — Find the single most expensive artwork in the collection
4. **The Prolific Artist** — Find the artist with the most artworks in the collection
5. **The Hidden Exhibition** — Find which exhibition has the highest total insured value

Each challenge includes expandable hints and a reveal answer button for learning purposes.

---

## SQL Queries Demonstrated

The project demonstrates all required SQL statement types:

- **JOINs** — Artworks with artist names and gallery locations; transactions with buyer details
- **ORDER BY** — Artworks sorted by estimated value descending
- **GROUP BY** — Artwork count and total value per artist; artworks per gallery location
- **Nested Queries** — Artworks worth more than average; artworks never in a transaction
- **Subqueries** — Collectors who bought forgeries; artists with high-value works

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| Database | PostgreSQL 18 |
| Backend | Node.js + Express.js |
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Fonts | Orbitron, Share Tech Mono, Rajdhani |
| Hosting | Render (backend + database) |
| Version Control | Git + GitHub |

---

## Project Structure

```
Art-Gallery-CTF/
│
├── backend/
│   ├── server.js          # Express server — serves frontend and API
│   ├── db.js              # PostgreSQL connection pool
│   ├── routes/
│   │   ├── query.js       # Query Lab endpoint (SELECT only)
│   │   ├── tables.js      # Database browser endpoint
│   │   └── ctf.js         # CTF challenge validation
│   ├── public/            # Frontend static files served by Express
│   │   ├── index.html
│   │   ├── style.css
│   │   └── script.js
│   └── package.json
│
├── database/
│   └── dallas_art_gallery_postgresql.sql   # Full schema + 50 data entries
│
├── docs/
│   └── art_gallery_edr.md                  # External Design Report (Phase 1-2)
│
└── README.md
```

---

## Setup Instructions

### Prerequisites
- Node.js 18+
- PostgreSQL 18
- pgAdmin 4 (recommended)

### Local Development

**1. Clone the repository**
```bash
git clone https://github.com/MohammedAsadKhan/Art-Gallery-CTF.git
cd Art-Gallery-CTF
```

**2. Install dependencies**
```bash
cd backend
npm install
```

**3. Create the database**

Open pgAdmin, create a database called `art_gallery`, open the Query Tool, load `database/dallas_art_gallery_postgresql.sql` and run it with F5.

**4. Configure environment variables**

Create a `.env` file inside the `backend` folder:
```
DB_HOST=localhost
DB_PORT=5432
DB_NAME=art_gallery
DB_USER=postgres
DB_PASSWORD=your_password
PORT=3000
```

**5. Start the server**
```bash
node server.js
```

**6. Open the website**

Visit `http://localhost:3000` in your browser.

---

## Security

- Only SELECT queries are permitted in the Query Lab and CTF sections
- Blocked keywords: INSERT, UPDATE, DELETE, DROP, ALTER, CREATE, TRUNCATE
- Rate limiting: 100 requests per 15 minutes per IP
- Query length limited to 2000 characters
- SSL enforced on all database connections

---

## Team Responsibilities

| Member | Role | Contributions |
|--------|------|---------------|
| Mohammed Asad Khan | Lead Programmer & Database Architect | Database schema, backend API, CTF logic, deployment |
| Ashton Baker | Data Manager & Tester | Data population, query testing, bug fixes |
| Christina LaCombe | Documentation & Frontend | EDR report, frontend design, UI testing |

---

## References

- Coronel, C., & Morris, S. (2023). *Database systems: Design, implementation, & management* (14th ed.). Cengage Learning.
- MAC Team. (2026). *Art Gallery Management System External Design Report*. Unpublished manuscript, Texas A&M University – Corpus Christi.
- PostgreSQL Global Development Group. (2024). *PostgreSQL 18 documentation*. Retrieved from https://www.postgresql.org/docs/
- SmartDraw. (n.d.). *What is an entity relationship diagram (ERD)?* Retrieved April 2026, from https://www.smartdraw.com/entity-relationship-diagram/
- Scribbr. (n.d.). *APA format for academic papers*. Retrieved from https://www.scribbr.com/apa-style/format/
