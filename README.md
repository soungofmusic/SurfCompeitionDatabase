# 🏄‍♂️ Surf Competition Database

![Database](https://img.shields.io/badge/Database-MariaDB-blue)
![Language](https://img.shields.io/badge/Language-Python-green)
![Framework](https://img.shields.io/badge/Framework-Flask-red)

A comprehensive database application for managing professional surf competitions, tracking surfers, heats, rounds, and scoring.

## 📋 Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Database Schema](#database-schema)
- [Database Relationships](#database-relationships)
- [Sample Data & Outputs](#sample-data--outputs)
- [Project Structure](#project-structure)
- [Setup Instructions](#setup-instructions)

## 🌊 Overview

The Surf Competition Database is designed to organize and track professional surfing events. It manages surfer profiles, competition details, rounds, heats, and scoring, providing a comprehensive system for competition organizers and surf enthusiasts.

![Dashboard Overview](/assets/dashboard.png)

*Dashboard showing active competitions and top-ranked surfers*

## ✨ Features

### Surfer Management
- Track professional surfers with detailed profiles
- Store information on origin country, age, and world ranking
- View performance history across competitions

![Surfer Management Interface](/assets/surfer-list.png)
*Surfer management interface showing filterable list of athletes*

### Competition Organization
- Create and manage surfing competitions with location and date information
- Organize competitions into rounds (Knockout, Quarter-Final, Semi-Final, Final)
- Set up heats within each round for surfer matchups

![Competition Management](/assets/competition-management.png)
*Competition management interface showing rounds and heats*

### Scoring System
- Record individual wave scores for surfers in each heat
- Calculate results and placements
- Generate competition standings

![Scoring Interface](/assets/scoring-interface.png)
*Heat scoring interface showing live score entry*

### Results & Analytics
- View comprehensive results by competition, round, or heat
- Filter and sort competition outcomes
- Track surfer performance history

![Results Dashboard](/assets/results-dashboard.png)
*Competition results showing surfer placements*

## 🗂️ Database Schema

The database is built around six main tables that organize the competitive surfing ecosystem:

![Surf Competition Database ERD](/assets/surf_competition_erd.jpg)
*Entity Relationship Diagram showing table relationships*

### Tables Overview
- **Surfers**: Stores athlete information including rankings
- **Competitions**: Tracks events with locations and dates
- **Rounds**: Organizes competition phases
- **Heats**: Individual matchups within rounds
- **Heat_Scores**: Individual scoring for surfers in heats (M:M resolution)
- **Results**: Competition outcomes at various levels (M:M resolution)

## 🔄 Database Relationships

### One-to-Many Relationships

**Competition to Rounds**: One competition has many rounds
```sql
-- Query to get all rounds for a specific competition
SELECT r.round_id, r.round_type 
FROM Rounds r
JOIN Competitions c ON r.competition_id = c.competition_id
WHERE c.competition_name = 'Lexus Pipe Pro';
```

**Rounds to Heats**: One round has many heats
```sql
-- Query to get all heats in a specific round
SELECT h.heat_id, h.heat_number
FROM Heats h
JOIN Rounds r ON h.round_id = r.round_id
WHERE r.round_type = 'Semi-Final' AND r.competition_id = 1;
```

### Many-to-Many Relationships

**Surfers to Heats**: Many surfers participate in many heats, resolved through Heat_Scores
```sql
-- Query to get all surfers in a specific heat with their scores
SELECT s.first_name, s.last_name, hs.score_num
FROM Surfers s
JOIN Heat_Scores hs ON s.surfer_id = hs.surfer_id
JOIN Heats h ON hs.heat_id = h.heat_id
WHERE h.heat_number = 1 
AND h.round_id = (SELECT round_id FROM Rounds WHERE round_type = 'Knockout' LIMIT 1);
```

**Surfers to Competitions**: Many surfers participate in many competitions, resolved through Results
```sql
-- Query to find all competitions a surfer has participated in
SELECT c.competition_name, c.competition_location, r.placement
FROM Results r
JOIN Competitions c ON r.competition_id = c.competition_id
JOIN Surfers s ON r.surfer_id = s.surfer_id
WHERE s.first_name = 'Griffin' AND s.last_name = 'Colapinto';
```

## 📊 Sample Data & Outputs

### Sample Surfers Data
```sql
SELECT * FROM Surfers LIMIT 5;
```

**Output:**
| surfer_id | first_name | last_name | origin_country | age | world_rank |
|-----------|------------|-----------|----------------|-----|------------|
| 1         | Griffin    | Colapinto | United States  | 25  | 1          |
| 2         | Jack       | Robinson  | Australia      | 26  | 2          |
| 3         | John John  | Florence  | Hawaii         | 31  | 3          |
| 4         | Ethan      | Ewing     | Australia      | 25  | 4          |
| 5         | Jordy      | Smith     | South Africa   | 36  | 5          |

### Competition Results Query
```sql
SELECT s.first_name, s.last_name, r.placement 
FROM Results r
JOIN Surfers s ON r.surfer_id = s.surfer_id
WHERE r.competition_id = 1 AND r.result_type = 'Competition'
ORDER BY r.placement;
```

**Output:**
| first_name | last_name | placement |
|------------|-----------|-----------|
| Griffin    | Colapinto | 1         |
| Jack       | Robinson  | 2         |
| John John  | Florence  | 3         |

### Heat Scores Query
```sql
SELECT s.first_name, s.last_name, hs.score_num
FROM Heat_Scores hs
JOIN Surfers s ON hs.surfer_id = s.surfer_id
JOIN Heats h ON hs.heat_id = h.heat_id
WHERE h.heat_number = 1
ORDER BY hs.score_num DESC;
```

**Output:**
| first_name | last_name | score_num |
|------------|-----------|-----------|
| Griffin    | Colapinto | 19.95     |
| Jack       | Robinson  | 18.00     |
| John John  | Florence  | 15.22     |

## 📁 Project Structure
- `DDL.SQL` - Database schema creation and sample data
- `app.py` - Main application file
- `templates/` - HTML templates
  - `home.html` - Dashboard template
  - `surfers.html` - Surfer management page
  - `competitions.html` - Competition management
  - `results.html` - Results viewing page
- `static/` - CSS, JS, and images
- `database/` - Database connection utilities

## 🚀 Setup Instructions

### Prerequisites
- Python 3.8+
- MariaDB or MySQL
- Flask and related dependencies

### Installation

1. Clone this repository
   ```bash
   git clone https://github.com/yourusername/surf-competition-db.git
   cd surf-competition-db
   ```

2. Create a virtual environment
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. Install dependencies
   ```bash
   pip install -r requirements.txt
   ```

4. Import the database schema
   ```bash
   mysql -u username -p < DDL.SQL
   ```

5. Configure database connection
   - Create a `.env` file with your database credentials
   ```
   DB_HOST=localhost
   DB_USER=your_username
   DB_PASSWORD=your_password
   DB_NAME=surf_competition
   ```

6. Run the application
   ```bash
   python app.py
   ```

7. Access the application
   - Open your browser and navigate to http://localhost:5000

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Authors
- Alan Massey
- Spencer Oung

---

*The following are inserting sample data into each table according to Schema. All sample data for Surfers and Competitions (Dates excluded) came from https://www.worldsurfleague.com/*
