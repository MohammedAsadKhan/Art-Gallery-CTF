# External Design Report (EDR)
## Art Gallery Management System with CTF Interface

**Project Name:** Art Gallery Database with Capture-The-Flag Challenge  
**Group Name:** MAC  
**Team Members:** Mohammed Asad Khan, Ashton Baker, Christina LaCombe  
**Date:** February 18, 2026

---

## 1. Project Overview

### 1.1 Purpose
This project develops a comprehensive Art Gallery Management Database System paired with an interactive Capture-The-Flag (CTF) web interface. The database manages all aspects of art gallery operations including artwork inventory, artist information, exhibitions, transactions, and authentication records. The CTF component gamifies SQL learning by presenting three mystery-solving challenges that require users to write SQL queries to uncover hidden clues within the database.

### 1.2 Project Goals
- Design and implement a fully normalized relational database using PostgreSQL
- Populate the database with realistic sample data containing hidden CTF clues
- Create an engaging web-based CTF interface with three progressive challenges
- Demonstrate practical SQL query skills through mystery-solving scenarios
- Provide a professional database solution suitable for real-world art gallery management

---

## 2. Database Design

### 2.1 Database Architecture

**Database Management System:** PostgreSQL  
**Database Name:** art_gallery  
**Normalization Level:** Third Normal Form (3NF)

### 2.2 Entity Relationship Overview

The database consists of 10 interconnected tables representing the core entities of an art gallery ecosystem:

#### Core Entities:
1. **artists** - Artist biographical and career information
2. **artworks** - Individual artwork catalog entries
3. **gallery_locations** - Physical gallery sites and security details
4. **exhibitions** - Temporary and permanent exhibition records
5. **staff** - Gallery employees and their roles
6. **collectors** - Buyers, donors, and art collectors
7. **transactions** - Sales, purchases, loans, and acquisitions
8. **authentications** - Artwork verification and appraisal records
9. **provenance_records** - Artwork ownership history
10. **exhibition_artworks** - Junction table linking exhibitions to displayed artworks

### 2.3 Key Relationships

**One-to-Many Relationships:**
- One artist creates many artworks
- One gallery location houses many artworks
- One gallery location hosts many exhibitions
- One gallery location employs many staff members
- One staff curator manages many exhibitions
- One collector participates in many transactions
- One artwork has many transaction records
- One artwork has many authentication records
- One artwork has many provenance entries

**Many-to-Many Relationships:**
- Exhibitions display multiple artworks; artworks appear in multiple exhibitions (resolved via exhibition_artworks junction table)

### 2.4 Table Specifications

#### Table: artists
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| artist_id | SERIAL | PRIMARY KEY | Unique identifier |
| first_name | VARCHAR(100) | NOT NULL | Artist's first name |
| last_name | VARCHAR(100) | NOT NULL | Artist's last name |
| birth_date | DATE | | Date of birth |
| death_date | DATE | | Date of death (if applicable) |
| nationality | VARCHAR(50) | | Country of origin |
| biography | TEXT | | Artist background (CTF clue location) |
| style | VARCHAR(50) | | Artistic movement/style |

#### Table: artworks
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| artwork_id | SERIAL | PRIMARY KEY | Unique identifier |
| title | VARCHAR(200) | NOT NULL | Artwork title |
| artist_id | INTEGER | FOREIGN KEY → artists | Creator reference |
| creation_year | INTEGER | | Year created |
| medium | VARCHAR(100) | | Material/technique |
| dimensions | VARCHAR(100) | | Size specifications |
| description | TEXT | | Artwork details (CTF clue location) |
| estimated_value | DECIMAL(12,2) | | Current market value |
| current_location_id | INTEGER | FOREIGN KEY → gallery_locations | Current storage |
| acquisition_date | DATE | | Date acquired by gallery |
| condition_status | VARCHAR(50) | | Conservation state |

#### Table: gallery_locations
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| location_id | SERIAL | PRIMARY KEY | Unique identifier |
| gallery_name | VARCHAR(200) | NOT NULL | Gallery branch name |
| address | VARCHAR(300) | NOT NULL | Street address |
| city | VARCHAR(100) | NOT NULL | City |
| country | VARCHAR(100) | NOT NULL | Country |
| security_level | INTEGER | CHECK (1-5) | Security rating (CTF element) |

#### Table: exhibitions
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| exhibition_id | SERIAL | PRIMARY KEY | Unique identifier |
| title | VARCHAR(200) | NOT NULL | Exhibition name |
| start_date | DATE | NOT NULL | Opening date |
| end_date | DATE | | Closing date |
| theme | VARCHAR(200) | | Exhibition theme/concept |
| curator_id | INTEGER | FOREIGN KEY → staff | Curator assignment |
| gallery_location_id | INTEGER | FOREIGN KEY → gallery_locations | Hosting venue |

#### Table: exhibition_artworks
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| exhibition_id | INTEGER | FOREIGN KEY → exhibitions | Exhibition reference |
| artwork_id | INTEGER | FOREIGN KEY → artworks | Artwork reference |
| display_room | VARCHAR(50) | | Specific room location |
| insurance_value | DECIMAL(12,2) | | Insured amount for display |
| PRIMARY KEY | (exhibition_id, artwork_id) | | Composite key |

#### Table: staff
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| staff_id | SERIAL | PRIMARY KEY | Unique identifier |
| first_name | VARCHAR(100) | NOT NULL | Employee first name |
| last_name | VARCHAR(100) | NOT NULL | Employee last name |
| role | VARCHAR(50) | NOT NULL | Job title (curator, security, appraiser, handler) |
| hire_date | DATE | NOT NULL | Employment start date |
| location_id | INTEGER | FOREIGN KEY → gallery_locations | Assigned location |
| clearance_level | INTEGER | CHECK (1-5) | Access authorization (CTF element) |

#### Table: collectors
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| collector_id | SERIAL | PRIMARY KEY | Unique identifier |
| name | VARCHAR(200) | NOT NULL | Collector/institution name |
| contact_info | VARCHAR(300) | | Email/phone |
| collector_type | VARCHAR(50) | | Individual/museum/corporate |
| reputation_score | INTEGER | CHECK (1-100) | Reliability rating (CTF element) |

#### Table: transactions
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| transaction_id | SERIAL | PRIMARY KEY | Unique identifier |
| artwork_id | INTEGER | FOREIGN KEY → artworks | Artwork involved |
| transaction_type | VARCHAR(50) | NOT NULL | Sale/loan/donation/theft recovery |
| transaction_date | DATE | NOT NULL | Transaction date (CTF clue) |
| amount | DECIMAL(12,2) | | Transaction value |
| buyer_id | INTEGER | FOREIGN KEY → collectors | Purchaser/recipient |
| seller_id | INTEGER | FOREIGN KEY → collectors | Seller/donor |
| staff_handler_id | INTEGER | FOREIGN KEY → staff | Processing employee |

#### Table: authentications
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| authentication_id | SERIAL | PRIMARY KEY | Unique identifier |
| artwork_id | INTEGER | FOREIGN KEY → artworks | Artwork being verified |
| appraiser_id | INTEGER | FOREIGN KEY → staff | Appraiser conducting review |
| authentication_date | DATE | NOT NULL | Verification date |
| result | VARCHAR(50) | NOT NULL | Authentic/forgery/uncertain |
| notes | TEXT | | Detailed findings (CTF clue location) |

#### Table: provenance_records
| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| provenance_id | SERIAL | PRIMARY KEY | Unique identifier |
| artwork_id | INTEGER | FOREIGN KEY → artworks | Artwork reference |
| owner_id | INTEGER | FOREIGN KEY → collectors | Historical owner |
| start_date | DATE | | Ownership began |
| end_date | DATE | | Ownership ended |
| acquisition_method | VARCHAR(100) | | How acquired (purchase/gift/inheritance) |

### 2.5 CTF Clue Integration Strategy

Hidden clues are embedded throughout the database in specific fields:
- **artist.biography** - Encoded messages about specific artworks
- **artwork.description** - Hidden codes in artwork descriptions
- **authentication.notes** - Cryptic references to other records
- **transaction.transaction_date** - Dates that form patterns or codes
- **staff.clearance_level** & **gallery_locations.security_level** - Numerical clues
- **collectors.reputation_score** - Scores that indicate trustworthy sources

---

## 3. CTF Web Interface Design

### 3.1 Technology Stack

**Frontend:**
- HTML5 for structure
- CSS3 for styling and animations
- Vanilla JavaScript for interactivity
- No authentication required (open access)

**Backend:**
- Node.js with Express.js framework
- PostgreSQL driver (pg library)
- CORS enabled for local development
- RESTful API endpoint for query execution

**Deployment:**
- Local development server (localhost)
- Backend runs on port 3000
- Frontend served as static files

### 3.2 User Interface Design

#### 3.2.1 Visual Design Principles
- **Theme:** Art gallery aesthetic with elegant, minimalist design
- **Color Scheme:** 
  - Primary: Deep navy (#1a1a2e)
  - Secondary: Gold accent (#d4af37)
  - Background: Off-white (#f5f5f5)
  - Success: Green (#2ecc71)
  - Error: Red (#e74c3c)
- **Typography:** 
  - Headers: Serif font (elegant, gallery-appropriate)
  - Body: Sans-serif (readable for code)
  - Monospace: For SQL query input
- **Layout:** Single-page application with smooth scrolling sections

#### 3.2.2 Page Structure

**Header Section:**
- Gallery logo/title: "Art Gallery Mystery Database"
- Subtitle: "Solve art mysteries using SQL queries"
- Brief instructions: "No login required - jump right in!"

**Challenge Section (3 progressive challenges):**

Each challenge card contains:
- Challenge number and title
- Mystery scenario description
- Hints (expandable/collapsible)
- SQL query input textarea
- "Execute Query" button
- Results display area
- Success indicator (shows when solved)

**Footer Section:**
- Database schema reference (collapsible table listing)
- Quick SQL syntax guide
- Credits and project information

### 3.3 Challenge Design

#### Challenge 1: "The Missing Masterpiece" (Easy)
**Difficulty:** Beginner  
**Concepts Tested:** SELECT, WHERE, basic filtering

**Scenario:**  
"A valuable painting has gone missing from the gallery! Security reports indicate it was a piece created in 1889 by an artist whose last name starts with 'V'. Find the artwork's title and current location."

**Required Query Skills:**
- SELECT specific columns
- WHERE clause with AND operator
- String pattern matching (LIKE)
- Join between artworks and artists tables

**Solution Involves:**
```sql
SELECT a.title, g.gallery_name 
FROM artworks a
JOIN artists ar ON a.artist_id = ar.artist_id
JOIN gallery_locations g ON a.current_location_id = g.location_id
WHERE ar.last_name LIKE 'V%' AND a.creation_year = 1889;
```

**Flag Format:** The artwork title becomes the flag  
**Success Message:** "You've located the missing piece! Van Gogh's 'Starry Night' is safely stored in the Modern Wing."

---

#### Challenge 2: "The Forgery Investigation" (Medium)
**Difficulty:** Intermediate  
**Concepts Tested:** JOINs, aggregation, subqueries

**Scenario:**  
"Art appraisers have flagged several suspicious authentications. Find all artworks that have been authenticated more than once with conflicting results (one 'authentic' and at least one 'forgery' or 'uncertain'). Who is the collector that purchased the most suspicious pieces?"

**Required Query Skills:**
- Multiple JOINs across 4+ tables
- GROUP BY and HAVING clauses
- COUNT aggregation
- Self-join or subquery to find conflicts

**Solution Involves:**
```sql
SELECT c.name, COUNT(DISTINCT t.artwork_id) as suspicious_purchases
FROM collectors c
JOIN transactions t ON c.collector_id = t.buyer_id
WHERE t.artwork_id IN (
  SELECT artwork_id 
  FROM authentications 
  GROUP BY artwork_id 
  HAVING COUNT(DISTINCT result) > 1
)
GROUP BY c.collector_id, c.name
ORDER BY suspicious_purchases DESC
LIMIT 1;
```

**Flag Format:** The collector's name  
**Success Message:** "Excellent detective work! You've identified the art fraud ring leader."

---

#### Challenge 3: "The Heist Blueprint" (Hard)
**Difficulty:** Advanced  
**Concepts Tested:** Complex JOINs, datetime filtering, multiple conditions, CTF logic

**Scenario:**  
"Intelligence suggests an art heist is planned. The target is a piece that meets ALL these criteria:
1. Currently displayed in an exhibition ending within the next 30 days
2. Located in a gallery with security_level ≤ 2
3. Estimated value over $5 million
4. Has been authenticated as 'authentic' within the last 2 years
5. The curator managing its exhibition has clearance_level < 4

Find the artwork title and the exact room where it's displayed."

**Required Query Skills:**
- Complex multi-table JOINs (6+ tables)
- Multiple WHERE conditions with AND logic
- Date calculations and comparisons
- Nested joins through junction table

**Solution Involves:**
```sql
SELECT a.title, ea.display_room, g.gallery_name
FROM artworks a
JOIN exhibition_artworks ea ON a.artwork_id = ea.artwork_id
JOIN exhibitions e ON ea.exhibition_id = e.exhibition_id
JOIN gallery_locations g ON a.current_location_id = g.location_id
JOIN staff s ON e.curator_id = s.staff_id
WHERE a.estimated_value > 5000000
  AND g.security_level <= 2
  AND e.end_date BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days'
  AND s.clearance_level < 4
  AND a.artwork_id IN (
    SELECT artwork_id 
    FROM authentications 
    WHERE result = 'authentic' 
      AND authentication_date >= CURRENT_DATE - INTERVAL '2 years'
  );
```

**Flag Format:** "artwork_title|room_number"  
**Success Message:** "You've thwarted the heist! Security has been doubled at the identified location."

### 3.4 User Experience Flow

1. **Landing:** User opens website, sees all three challenges locked (Challenge 1 unlocked)
2. **Attempt:** User reads scenario, writes SQL query, clicks "Execute Query"
3. **Feedback:** 
   - Syntax errors shown in red
   - Valid queries return results in formatted table
   - Correct solution triggers success animation and unlocks next challenge
4. **Progression:** Challenges must be completed in order (1 → 2 → 3)
5. **Completion:** Upon solving Challenge 3, victory screen with team credits

### 3.5 Technical Implementation Details

#### Frontend Components

**query-input.js**
- Handles SQL query input validation
- Sends POST request to backend API
- Displays formatted results or error messages
- Checks if query result matches expected flag

**challenge-manager.js**
- Tracks which challenges are unlocked/completed
- Stores progress in browser localStorage
- Manages UI state (locked/unlocked/completed)
- Triggers success animations

**results-renderer.js**
- Formats SQL query results as HTML tables
- Syntax highlighting for error messages
- Responsive table design for mobile

#### Backend API

**Endpoint:** `POST /api/query`

**Request Body:**
```json
{
  "query": "SELECT * FROM artists;",
  "challenge_id": 1
}
```

**Response (Success):**
```json
{
  "success": true,
  "data": [
    {"artist_id": 1, "first_name": "Vincent", "last_name": "Van Gogh"},
    ...
  ],
  "row_count": 15,
  "execution_time_ms": 23
}
```

**Response (Error):**
```json
{
  "success": false,
  "error": "syntax error at or near \"FORM\"",
  "hint": "Did you mean FROM instead of FORM?"
}
```

**Security Measures:**
- Read-only database user for CTF queries
- Query timeout limit (5 seconds max)
- Restricted SQL commands (no DROP, DELETE, UPDATE, INSERT)
- Input sanitization to prevent SQL injection
- Rate limiting to prevent abuse

### 3.6 Visual Mockup Description

**Challenge Card Layout:**
```
┌─────────────────────────────────────────────────────┐
│ 🔒 CHALLENGE 2: The Forgery Investigation          │
│ ─────────────────────────────────────────────────── │
│                                                     │
│ 📖 SCENARIO:                                        │
│ [Mystery description text here...]                 │
│                                                     │
│ 💡 HINTS: [▼ Click to expand]                      │
│                                                     │
│ ✍️ YOUR SQL QUERY:                                  │
│ ┌─────────────────────────────────────────────┐   │
│ │ SELECT ...                                  │   │
│ │                                             │   │
│ │                                             │   │
│ └─────────────────────────────────────────────┘   │
│                                                     │
│              [🔍 Execute Query]                     │
│                                                     │
│ 📊 RESULTS:                                         │
│ ┌─────────────────────────────────────────────┐   │
│ │ [Table results display here]                │   │
│ └─────────────────────────────────────────────┘   │
│                                                     │
│ Status: ⏳ Locked - Complete Challenge 1 first     │
└─────────────────────────────────────────────────────┘
```

**Color States:**
- Locked: Gray background, lock icon
- Active: White background, blue accent border
- Completed: Green background, checkmark icon

---

## 4. Implementation Plan

### 4.1 Phase Timeline

**Phase 1: Database Design & Setup (Week 1-2)**
- Write complete CREATE TABLE scripts
- Design ER diagram
- Set up PostgreSQL database locally
- Create database schema with all constraints

**Phase 2: Data Population (Week 2-3)**
- Write INSERT scripts for sample data
- Embed CTF clues strategically
- Test data integrity and relationships
- Verify CTF challenge solutions work

**Phase 3: Backend Development (Week 3-4)**
- Set up Node.js/Express server
- Implement database connection
- Create /api/query endpoint
- Add security restrictions and validation

**Phase 4: Frontend Development (Week 4-5)**
- Design HTML/CSS interface
- Implement JavaScript challenge logic
- Build query input and results display
- Add progress tracking and animations

**Phase 5: Testing & Refinement (Week 5-6)**
- Test all three CTF challenges
- Debug edge cases
- Improve UI/UX based on testing
- Write documentation

**Phase 6: Final Submission (Week 6)**
- Complete all documentation
- Record demo video
- Prepare presentation
- Submit project

### 4.2 Team Responsibilities

**Mohammed (Lead Programmer & Database Architect):**
- Database schema design and implementation
- Backend API development
- CTF challenge logic implementation
- Integration of frontend and backend

**Ashton (Database Tester & Data Manager):**
- Sample data creation and population
- CTF clue embedding in database
- Query testing and validation
- Backend testing and bug fixes

**Christina (Documentation & Frontend Assistant):**
- All project documentation (EDR, reports, diagrams)
- Frontend HTML/CSS design
- User interface testing
- Final presentation preparation

---

## 5. Expected Outcomes

### 5.1 Learning Objectives Met
- Demonstrate understanding of relational database design principles
- Apply normalization techniques to reduce redundancy
- Implement complex SQL queries with multiple JOINs
- Create a functional database-driven web application
- Understand database security and access control

### 5.2 Deliverables
1. **PostgreSQL Database**
   - Fully normalized schema (3NF)
   - Sample data with embedded CTF clues
   - SQL scripts for reproduction

2. **ER Diagram**
   - Visual representation of all entities and relationships
   - Clearly marked cardinalities (1:1, 1:M, M:M)

3. **CTF Web Application**
   - Three progressive SQL challenges
   - Clean, professional interface
   - Functional query execution system

4. **Documentation**
   - External Design Report (this document)
   - Database schema documentation
   - User guide for CTF challenges
   - Installation and setup instructions

5. **Presentation**
   - Live demonstration of database and CTF
   - Explanation of design decisions
   - Discussion of challenges and solutions

### 5.3 Success Criteria
- Database passes all integrity constraints
- All foreign key relationships properly enforced
- CTF challenges solvable with correct SQL queries
- Web interface functions without errors
- Documentation is complete and professional
- Project demonstrates SQL proficiency at advanced level

---

## 6. Technical Requirements

### 6.1 Software Dependencies

**Database:**
- PostgreSQL 14+ 

**Backend:**
- Node.js 16+
- Express.js 4.18+
- pg (node-postgres) 8.11+
- cors 2.8+
- dotenv 16+

**Frontend:**
- Modern web browser (Chrome, Firefox, Safari, Edge)
- No additional libraries required (vanilla JS)

**Development Tools:**
- pgAdmin 4 or DBeaver (database management)
- VS Code or similar text editor
- Git for version control
- GitHub for repository hosting

### 6.2 System Architecture

```
┌─────────────────┐
│   Web Browser   │
│   (Frontend)    │
└────────┬────────┘
         │ HTTP POST /api/query
         │ { query: "SELECT..." }
         ▼
┌─────────────────┐
│  Express.js     │
│  Backend Server │
│  (Port 3000)    │
└────────┬────────┘
         │ SQL Query Execution
         │ via pg library
         ▼
┌─────────────────┐
│  PostgreSQL     │
│  Database       │
│  art_gallery    │
└─────────────────┘
```

### 6.3 Security Considerations

**Database Security:**
- Read-only user account for CTF queries
- Restricted permissions (no DDL/DML commands allowed)
- Connection pooling with maximum connections limit
- Prepared statements to prevent SQL injection

**API Security:**
- CORS configuration for localhost only
- Request timeout enforcement
- SQL command whitelist (only SELECT allowed)
- Query length limitation
- Rate limiting per IP address

**Data Security:**
- Environment variables for sensitive credentials
- .gitignore for .env files
- No hardcoded passwords in source code

---

## 7. Conclusion

This project combines rigorous database design with interactive gamification to create both a functional Art Gallery Management System and an engaging SQL learning tool. The CTF component transforms what could be a standard academic database project into an immersive mystery-solving experience that reinforces SQL concepts through practical application.

By completing this project, the MAC team will demonstrate:
- Advanced database design and normalization skills
- Proficiency in complex SQL queries and joins
- Full-stack web development capabilities
- Creative problem-solving and project planning
- Professional documentation and presentation skills

The result will be a portfolio-worthy project that showcases technical competence while remaining genuinely fun and educational for users.

---

**Document Version:** 1.0  
**Last Updated:** February 18, 2026  
**Prepared By:** MAC Team (Mohammed Asad Khan, Ashton Baker, Christina LaCombe)
