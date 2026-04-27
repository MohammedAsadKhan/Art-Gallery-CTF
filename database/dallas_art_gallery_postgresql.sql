
-- ============================================================
-- Dallas Art Gallery Management System
-- Phase 3: Database Creation
-- Team MAC: Mohammed Asad Khan, Ashton Baker, Christina LaCombe
-- COSC 3336: Database Management Systems
-- Spring 2026
-- ============================================================

-- Drop tables if they exist (clean re-run)
DROP TABLE IF EXISTS exhibition_artworks;
DROP TABLE IF EXISTS authentications;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS exhibitions;
DROP TABLE IF EXISTS artworks;
DROP TABLE IF EXISTS collectors;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS gallery_locations;

-- ============================================================
-- TABLE CREATION
-- ============================================================

CREATE TABLE gallery_locations (
    location_id    SERIAL PRIMARY KEY,
    gallery_name   VARCHAR(200) NOT NULL,
    address        VARCHAR(300) NOT NULL,
    city           VARCHAR(100) NOT NULL,
    country        VARCHAR(100) NOT NULL,
    security_level INT CHECK (security_level BETWEEN 1 AND 5)
);

CREATE TABLE artists (
    artist_id   SERIAL PRIMARY KEY,
    first_name  VARCHAR(100) NOT NULL,
    last_name   VARCHAR(100) NOT NULL,
    birth_date  DATE,
    nationality VARCHAR(100),
    biography   TEXT,
    style       VARCHAR(100)
);

CREATE TABLE artworks (
    artwork_id          SERIAL PRIMARY KEY,
    title               VARCHAR(200) NOT NULL,
    artist_id           INT REFERENCES artists(artist_id),
    creation_year       INT,
    medium              VARCHAR(100),
    description         TEXT,
    estimated_value     DECIMAL(12,2),
    current_location_id INT REFERENCES gallery_locations(location_id),
    condition_status    VARCHAR(50)
);

CREATE TABLE staff (
    staff_id        SERIAL PRIMARY KEY,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    role            VARCHAR(100) NOT NULL,
    hire_date       DATE NOT NULL,
    location_id     INT REFERENCES gallery_locations(location_id),
    clearance_level INT CHECK (clearance_level BETWEEN 1 AND 5)
);

CREATE TABLE collectors (
    collector_id     SERIAL PRIMARY KEY,
    name             VARCHAR(200) NOT NULL,
    contact_info     VARCHAR(300),
    collector_type   VARCHAR(50),
    reputation_score INT CHECK (reputation_score BETWEEN 1 AND 100)
);

CREATE TABLE exhibitions (
    exhibition_id       SERIAL PRIMARY KEY,
    title               VARCHAR(200) NOT NULL,
    start_date          DATE NOT NULL,
    end_date            DATE,
    theme               VARCHAR(200),
    curator_id          INT REFERENCES staff(staff_id),
    gallery_location_id INT REFERENCES gallery_locations(location_id)
);

CREATE TABLE exhibition_artworks (
    exhibition_id   INT REFERENCES exhibitions(exhibition_id),
    artwork_id      INT REFERENCES artworks(artwork_id),
    display_room    VARCHAR(100),
    insurance_value DECIMAL(12,2),
    PRIMARY KEY (exhibition_id, artwork_id)
);

CREATE TABLE transactions (
    transaction_id   SERIAL PRIMARY KEY,
    artwork_id       INT REFERENCES artworks(artwork_id),
    transaction_type VARCHAR(50) NOT NULL,
    transaction_date DATE NOT NULL,
    amount           DECIMAL(12,2),
    buyer_id         INT REFERENCES collectors(collector_id),
    seller_id        INT REFERENCES collectors(collector_id)
);

CREATE TABLE authentications (
    authentication_id   SERIAL PRIMARY KEY,
    artwork_id          INT REFERENCES artworks(artwork_id),
    appraiser_id        INT REFERENCES staff(staff_id),
    authentication_date DATE NOT NULL,
    result              VARCHAR(50) NOT NULL,
    notes               TEXT
);

-- ============================================================
-- DATA INSERTION
-- ============================================================

-- GALLERY LOCATIONS (5 entries)
INSERT INTO gallery_locations (gallery_name, address, city, country, security_level) VALUES
('Dallas Art Gallery - Main',       '1717 North Harwood Street', 'Dallas', 'USA', 5),
('Dallas Art Gallery - Uptown',     '2100 McKinney Avenue',      'Dallas', 'USA', 4),
('Dallas Art Gallery - Deep Ellum', '2800 Main Street',          'Dallas', 'USA', 3),
('Dallas Art Gallery - Oak Cliff',  '408 West Seventh Street',   'Dallas', 'USA', 2),
('Dallas Art Gallery - Frisco',     '8000 Gaylord Parkway',      'Frisco', 'USA', 3);

-- ARTISTS (10 entries)
INSERT INTO artists (first_name, last_name, birth_date, nationality, biography, style) VALUES
('Elena',   'Vasquez',   '1970-03-15', 'Mexican',          'Celebrated muralist known for vibrant street scenes and cultural storytelling.', 'Muralism'),
('James',   'Whitfield', '1945-07-22', 'American',         'Spent four decades painting the American Southwest. Known for wide open landscapes.', 'Realism'),
('Sophia',  'Renard',    '1988-01-09', 'French',           'Paris-trained abstract artist who relocated to Dallas. Works in bold color and geometry.', 'Abstract'),
('Marcus',  'Okafor',    '1962-05-30', 'Nigerian',         'Bridges African tradition and modern expression through sculpture and painting.', 'Contemporary'),
('Lily',    'Chen',      '1979-11-17', 'Chinese-American', 'Blends traditional Chinese ink techniques with modern digital influence.', 'Mixed Media'),
('Roberto', 'Delgado',   '1955-08-04', 'Spanish',          'Master portraitist whose subjects included politicians and celebrities.', 'Portraiture'),
('Ava',     'Sterling',  '1991-02-28', 'American',         'One of Dallas''s most talked-about emerging artists. Works in minimalist abstraction.', 'Minimalism'),
('Hiroshi', 'Tanaka',    '1950-09-11', 'Japanese',         'Creates haunting landscapes inspired by rural Japan and the Texas plains.', 'Impressionism'),
('Fatima',  'Al-Rashid', '1983-06-06', 'Emirati',          'Internationally recognized sculptor whose installations span from Dubai to New York.', 'Sculpture'),
('Derek',   'Monroe',    '1967-12-01', 'American',         'Paints large-scale industrial scenes with near-photographic quality. Dallas skyline series is iconic.', 'Hyperrealism');

-- ARTWORKS (50 entries)
INSERT INTO artworks (title, artist_id, creation_year, medium, description, estimated_value, current_location_id, condition_status) VALUES
-- Elena Vasquez (artist 1)
('Sunrise Over the Plaza',    1, 2005, 'Oil on canvas',     'Warm morning light floods a busy market square.',           120000.00, 1, 'Excellent'),
('Festival of Colors',        1, 2008, 'Acrylic on canvas', 'Vibrant depiction of a traditional street festival.',        95000.00, 1, 'Excellent'),
('The Market Woman',          1, 2011, 'Oil on canvas',     'Portrait of a vendor surrounded by her goods.',              75000.00, 2, 'Good'),
('Barrio at Dusk',            1, 2015, 'Mural on panel',    'A neighborhood comes alive under golden hour light.',        88000.00, 3, 'Good'),
('Marigold Fields',           1, 2019, 'Oil on canvas',     'Endless rows of marigolds stretching to the horizon.',       60000.00, 4, 'Excellent'),

-- James Whitfield (artist 2)
('Desert Patience',           2, 1998, 'Oil on canvas',     'A vast sun-bleached landscape with a lone cactus.',          85000.00, 1, 'Good'),
('Red Rock Canyon',           2, 2001, 'Oil on canvas',     'Towering canyon walls bathed in afternoon sun.',             90000.00, 1, 'Good'),
('The Long Road',             2, 2005, 'Watercolor',        'A dust road cuts through an empty Texas plain.',             55000.00, 2, 'Fair'),
('Monsoon Season',            2, 2010, 'Oil on canvas',     'Dark clouds roll over a flat desert landscape.',             70000.00, 3, 'Good'),
('Last Light in the Valley',  2, 2014, 'Oil on canvas',     'Sunset over a remote valley, painted on-site in Arizona.',   78000.00, 4, 'Good'),

-- Sophia Renard (artist 3)
('Red Abstraction No. 7',     3, 2018, 'Acrylic on canvas', 'Bold red composition with layered geometric shapes.',        47000.00, 2, 'Excellent'),
('Blue Composition',          3, 2019, 'Acrylic on canvas', 'Cool blues and sharp angles create a sense of calm tension.',42000.00, 2, 'Excellent'),
('Crimson Fields',            3, 2020, 'Acrylic on canvas', 'Deep crimson dissolves into abstract horizon lines.',        88000.00, 2, 'Excellent'),
('The Forgotten Gate',        3, 2021, 'Digital on metal',  'A surreal rusted gate surrounded by blooming flowers.',      62000.00, 3, 'Excellent'),
('Yellow Study No. 2',        3, 2022, 'Acrylic on canvas', 'A study in yellow — warmth and tension coexisting.',         39000.00, 5, 'Excellent'),

-- Marcus Okafor (artist 4)
('Lagos to Dallas',           4, 2015, 'Mixed media',       'Yoruba patterns woven into a Dallas skyline panorama.',      95000.00, 2, 'Excellent'),
('Ancestor Voices',           4, 2018, 'Bronze sculpture',  'A cast bronze face composed of many interlocking faces.',    72000.00, 4, 'Excellent'),
('The Crossing',              4, 2016, 'Oil on canvas',     'A figure at the midpoint between two worlds.',               65000.00, 1, 'Good'),
('River of Names',            4, 2019, 'Mixed media',       'Names of ancestors flow like a river across the canvas.',    58000.00, 3, 'Good'),
('Homecoming',                4, 2021, 'Acrylic on canvas', 'A joyful scene of return and belonging.',                    80000.00, 2, 'Excellent'),

-- Lily Chen (artist 5)
('Ink and Circuit',           5, 2019, 'Ink and resin',     'Chinese ink strokes flow into circuit board patterns.',      38000.00, 3, 'Excellent'),
('Dragon and Data',           5, 2020, 'Mixed media',       'A traditional dragon rendered in fiber optic threads.',      44000.00, 3, 'Excellent'),
('Calligraphy in Code',       5, 2021, 'Ink on paper',      'Ancient calligraphy characters written in binary.',          29000.00, 4, 'Excellent'),
('Jade Network',              5, 2018, 'Resin and jade',    'Jade fragments embedded in a grid of transparent resin.',    51000.00, 2, 'Good'),
('The Silent Byte',           5, 2022, 'Digital print',     'A meditative piece exploring the space between signals.',    33000.00, 5, 'Excellent'),

-- Roberto Delgado (artist 6)
('The Senator''s Face',       6, 2002, 'Oil on canvas',     'A formal portrait of a Dallas city official.',               55000.00, 1, 'Good'),
('Lady in Blue',              6, 2005, 'Oil on canvas',     'An elegant portrait of an unknown woman in a blue dress.',   62000.00, 1, 'Good'),
('The Professor',             6, 2008, 'Oil on canvas',     'A seated academic surrounded by towers of books.',           48000.00, 2, 'Fair'),
('Self Portrait at 50',       6, 2010, 'Oil on canvas',     'Delgado''s reflective self-portrait on his 50th birthday.',  90000.00, 1, 'Excellent'),
('Young Cellist',             6, 2013, 'Oil on canvas',     'A child deeply absorbed in playing the cello.',              57000.00, 4, 'Good'),

-- Ava Sterling (artist 7)
('White Square Study',        7, 2022, 'Acrylic on canvas', 'A near-blank canvas with a single off-center white square.', 77000.00, 2, 'Excellent'),
('Nothing and Everything',    7, 2021, 'Acrylic on canvas', 'Two large color fields divided by a hair-thin line.',        41000.00, 3, 'Excellent'),
('Minimal Blue',              7, 2020, 'Acrylic on canvas', 'A single horizontal blue brushstroke on a white field.',     35000.00, 5, 'Excellent'),
('Empty Room',                7, 2023, 'Oil on canvas',     'A meticulously painted empty white room.',                   66000.00, 2, 'Excellent'),
('The Pause',                 7, 2019, 'Acrylic on canvas', 'A monochrome canvas interrupted by a single gray dot.',      30000.00, 4, 'Excellent'),

-- Hiroshi Tanaka (artist 8)
('Plains at Dusk',            8, 1992, 'Watercolor',        'Infinite Texas plains stretching toward an orange horizon.',  67000.00, 4, 'Fair'),
('Rain on the Pond',          8, 1995, 'Ink on paper',      'Ripples spread across a still pond in a quiet rain.',         50000.00, 3, 'Fair'),
('Mountain Path',             8, 2000, 'Oil on canvas',     'A winding mountain trail disappearing into mist.',            72000.00, 1, 'Good'),
('Cherry Season',             8, 2003, 'Watercolor',        'Cherry blossoms in full bloom along a city walkway.',         58000.00, 2, 'Good'),
('Winter Field',              8, 2007, 'Ink on paper',      'A snow-covered field with a single bare tree.',               45000.00, 4, 'Fair'),

-- Fatima Al-Rashid (artist 9)
('Steel Lotus',               9, 2017, 'Stainless steel',   'A massive lobby lotus crafted from polished steel.',         200000.00, 1, 'Excellent'),
('Geometric Garden',          9, 2019, 'Aluminum',          'Interlocking aluminum arches forming a garden pavilion.',    145000.00, 5, 'Excellent'),
('The Veil',                  9, 2018, 'Bronze mesh',       'A cascading bronze mesh resembling flowing fabric.',         110000.00, 2, 'Excellent'),
('Orbit',                     9, 2021, 'Steel and glass',   'Concentric steel rings enclosing a glass sphere.',           175000.00, 1, 'Excellent'),
('Sand Dune',                 9, 2015, 'Sandstone resin',   'Sculpted resin shaped to mimic desert dune formations.',      88000.00, 3, 'Good'),

-- Derek Monroe (artist 10)
('Skyline Series I',         10, 2014, 'Oil on canvas',     'The Dallas skyline at twilight, every window hand-painted.', 150000.00, 1, 'Excellent'),
('Skyline Series II',        10, 2015, 'Oil on canvas',     'Morning perspective of downtown Dallas.',                    165000.00, 1, 'Excellent'),
('Skyline Series III',       10, 2016, 'Oil on canvas',     'The skyline reflected in the Trinity River at night.',       155000.00, 1, 'Excellent'),
('The Bridge',               10, 2018, 'Oil on canvas',     'The Margaret Hunt Hill Bridge in hyperrealistic detail.',    120000.00, 2, 'Excellent'),
('Evening in Frisco',        10, 2023, 'Oil on canvas',     'The Frisco suburban skyline under a violet evening sky.',    130000.00, 5, 'Excellent');

-- STAFF (8 entries)
INSERT INTO staff (first_name, last_name, role, hire_date, location_id, clearance_level) VALUES
('Sandra', 'Torres',  'Curator',   '2010-06-01', 1, 5),
('Kevin',  'Park',    'Appraiser', '2015-03-15', 1, 4),
('Mia',    'Johnson', 'Curator',   '2018-09-10', 2, 4),
('Leon',   'Harris',  'Security',  '2012-01-20', 1, 2),
('Priya',  'Nair',    'Appraiser', '2020-07-01', 3, 3),
('Carlos', 'Rivera',  'Handler',   '2017-04-11', 2, 2),
('Diana',  'Webb',    'Curator',   '2019-11-05', 4, 3),
('Tom',    'Nguyen',  'Security',  '2021-02-28', 5, 1);

-- COLLECTORS (7 entries)
INSERT INTO collectors (name, contact_info, collector_type, reputation_score) VALUES
('The Harrington Foundation',  'harrington@foundation.org', 'Corporate',  95),
('Victor Ashby',               'v.ashby@privatemail.com',   'Individual', 82),
('Dallas Museum Acquisitions', 'acquisitions@dma.org',      'Museum',     99),
('Celeste Dumont',             'cdumont@artworld.fr',       'Individual', 74),
('Lone Star Arts Trust',       'contact@lonestararts.org',  'Corporate',  88),
('Raymond Cross',              'rcross@businessmail.com',   'Individual', 61),
('Global Art Exchange',        'info@globalartex.com',      'Corporate',  45);

-- EXHIBITIONS (5 entries)
INSERT INTO exhibitions (title, start_date, end_date, theme, curator_id, gallery_location_id) VALUES
('Visions of Dallas', '2023-01-15', '2023-04-15', 'Art inspired by Dallas culture and landscape', 1, 1),
('Abstract Now',      '2023-05-01', '2023-08-31', 'Contemporary abstraction from local artists',  3, 2),
('Roots and Routes',  '2023-09-10', '2023-12-10', 'Cultural identity and migration themes',       7, 4),
('Steel and Sky',     '2024-02-01', '2024-05-01', 'Large-scale sculpture and installations',      1, 1),
('Frisco Debut',      '2024-03-01', '2024-06-30', 'Grand opening for the Frisco Wing',            3, 5);

-- EXHIBITION ARTWORKS (10 entries)
INSERT INTO exhibition_artworks (exhibition_id, artwork_id, display_room, insurance_value) VALUES
(1, 46, 'Room A',    155000.00),
(1, 47, 'Room A',    170000.00),
(1,  6, 'Room B',     90000.00),
(2, 11, 'Room A',     50000.00),
(2, 13, 'Room B',     90000.00),
(2, 31, 'Room C',     80000.00),
(3, 16, 'Room A',    100000.00),
(3, 17, 'Room B',     75000.00),
(4, 41, 'Main Hall', 210000.00),
(5, 50, 'Grand Hall',135000.00);

-- TRANSACTIONS (8 entries)
INSERT INTO transactions (artwork_id, transaction_type, transaction_date, amount, buyer_id, seller_id) VALUES
(46, 'Sale',     '2015-06-10', 150000.00, 1, NULL),
( 6, 'Donation', '2008-07-14',      0.00, 3, 2),
(41, 'Sale',     '2018-04-01', 200000.00, 1, NULL),
(31, 'Sale',     '2023-03-03',  77000.00, 6, NULL),
(13, 'Purchase', '2021-07-19',  88000.00, 5, 4),
(16, 'Loan',     '2016-09-05',      0.00, 3, NULL),
(50, 'Sale',     '2024-01-05', 130000.00, 5, NULL),
(36, 'Sale',     '2011-08-20',  67000.00, 2, NULL);

-- AUTHENTICATIONS (7 entries)
INSERT INTO authentications (artwork_id, appraiser_id, authentication_date, result, notes) VALUES
(46, 2, '2015-05-01', 'Authentic', 'Verified against Monroe studio records. Certificate issued.'),
( 6, 2, '2008-06-01', 'Authentic', 'Cross-referenced with Whitfield estate catalog. No anomalies found.'),
(41, 2, '2018-03-01', 'Authentic', 'Al-Rashid confirmed via video conference. Serial number matches foundry.'),
(31, 5, '2023-02-15', 'Forgery',   'Signature pigment does not match Sterling known palette. Do not process sale.'),
(13, 5, '2021-07-01', 'Authentic', 'Renard certificate on file. Acrylic compound matches 2020 works.'),
(16, 2, '2016-08-20', 'Authentic', 'Okafor confirmed via signed letter. Materials consistent with 2015 catalog.'),
(47, 2, '2016-01-10', 'Authentic', 'Second Monroe skyline piece. Verified by studio assistant records.');


-- ============================================================
-- REQUIRED SQL QUERIES
-- ============================================================

-- 1. JOIN: Artworks with artist name and gallery location
SELECT
    a.title,
    ar.first_name || ' ' || ar.last_name AS artist,
    gl.gallery_name,
    a.estimated_value
FROM artworks a
JOIN artists ar ON a.artist_id = ar.artist_id
JOIN gallery_locations gl ON a.current_location_id = gl.location_id
ORDER BY a.estimated_value DESC;

-- 2. JOIN: Transactions with artwork title and buyer name
SELECT
    t.transaction_id,
    aw.title AS artwork,
    t.transaction_type,
    t.transaction_date,
    t.amount,
    c.name AS buyer
FROM transactions t
JOIN artworks aw ON t.artwork_id = aw.artwork_id
LEFT JOIN collectors c ON t.buyer_id = c.collector_id
ORDER BY t.transaction_date DESC;

-- 3. ORDER BY: All artworks sorted by estimated value
SELECT title, estimated_value, condition_status, creation_year
FROM artworks
ORDER BY estimated_value DESC;

-- 4. GROUP BY: Number of artworks and total value per artist
SELECT
    ar.first_name || ' ' || ar.last_name AS artist_name,
    COUNT(a.artwork_id) AS total_artworks,
    SUM(a.estimated_value) AS total_value,
    AVG(a.estimated_value) AS avg_value
FROM artists ar
JOIN artworks a ON ar.artist_id = a.artist_id
GROUP BY ar.artist_id, ar.first_name, ar.last_name
ORDER BY total_value DESC;

-- 5. GROUP BY: Artworks per gallery location
SELECT
    gl.gallery_name,
    gl.security_level,
    COUNT(a.artwork_id) AS artwork_count,
    SUM(a.estimated_value) AS total_value
FROM gallery_locations gl
LEFT JOIN artworks a ON gl.location_id = a.current_location_id
GROUP BY gl.location_id, gl.gallery_name, gl.security_level
ORDER BY artwork_count DESC;

-- 6. NESTED QUERY: Artworks worth more than the average estimated value
SELECT title, estimated_value, creation_year
FROM artworks
WHERE estimated_value > (
    SELECT AVG(estimated_value) FROM artworks
)
ORDER BY estimated_value DESC;

-- 7. SUBQUERY: Collectors who purchased artworks flagged as forgeries
SELECT name, collector_type, reputation_score
FROM collectors
WHERE collector_id IN (
    SELECT buyer_id FROM transactions
    WHERE artwork_id IN (
        SELECT artwork_id FROM authentications WHERE result = 'Forgery'
    )
);

-- 8. SUBQUERY: Artists who have at least one artwork valued over $100,000
SELECT first_name, last_name, nationality, style
FROM artists
WHERE artist_id IN (
    SELECT DISTINCT artist_id FROM artworks
    WHERE estimated_value > 100000
);

-- 9. JOIN with GROUP BY: Exhibitions and their artwork count
SELECT
    e.title AS exhibition,
    gl.gallery_name,
    e.start_date,
    e.end_date,
    COUNT(ea.artwork_id) AS artworks_shown,
    SUM(ea.insurance_value) AS total_insured
FROM exhibitions e
JOIN gallery_locations gl ON e.gallery_location_id = gl.location_id
LEFT JOIN exhibition_artworks ea ON e.exhibition_id = ea.exhibition_id
GROUP BY e.exhibition_id, e.title, gl.gallery_name, e.start_date, e.end_date
ORDER BY artworks_shown DESC;

-- 10. NESTED QUERY: Artworks that have never been in a transaction
SELECT title, estimated_value, creation_year
FROM artworks
WHERE artwork_id NOT IN (
    SELECT artwork_id FROM transactions
)
ORDER BY estimated_value DESC;
