-- Authors: Alan Massey, Spencer Oung
-- Sets foreign key checks and auto commit to 0 to reduce import errors on repeat imports
SET FOREIGN_KEY_CHECKS=0; 
SET AUTOCOMMIT = 0;

-- Creates tables in database according to project Schema
-- Surfers table structure
CREATE OR REPLACE TABLE Surfers
(
    surfer_id INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    origin_country VARCHAR(255) NOT NULL,
    age INT(11) NOT NULL,
    world_rank INT(11) NOT NULL,
    PRIMARY KEY (surfer_id)
);

-- Competitions table structure
CREATE OR REPLACE TABLE Competitions
(
    competition_id INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
    competition_name VARCHAR(255) NOT NULL,
    competition_location VARCHAR(255) NOT NULL,
    competition_date DATE NOT NULL,
    PRIMARY KEY (competition_id)
);

-- Rounds table structure
CREATE OR REPLACE TABLE Rounds
(
    round_id INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
    competition_id INT(11) NOT NULL,
    round_type VARCHAR(50) NOT NULL,
    PRIMARY KEY (round_id),
    FOREIGN KEY (competition_id) REFERENCES Competitions(competition_id) ON DELETE CASCADE
);

-- Heats table structure
CREATE OR REPLACE TABLE Heats
(
    heat_id INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
    round_id INT(11) NOT NULL,
    heat_number INT(11) NOT NULL,
    PRIMARY KEY (heat_id),
    FOREIGN KEY (round_id) REFERENCES Rounds(round_id) ON DELETE CASCADE
);

-- Heat Scores Table Structure, table used to find individual scores of a heat and correlate them to a surfer, resolving Many:Many relationship between Surfers and Heats
CREATE OR REPLACE TABLE Heat_Scores
(
    score_id INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
    surfer_id INT(11) NOT NULL,
    heat_id INT(11) NOT NULL,
    score_num DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (score_id),
    FOREIGN KEY (surfer_id) REFERENCES Surfers(surfer_id) ON DELETE CASCADE,
    FOREIGN KEY (heat_id) REFERENCES Heats(heat_id) ON DELETE CASCADE
);

-- Results table structure.  Table functions as intersection to resolve Many:Many relationships between Surfers, Competitions, Rounds, Heats
CREATE OR REPLACE TABLE Results
(
    result_id INT(11) UNIQUE NOT NULL AUTO_INCREMENT,
    surfer_id INT(11) NOT NULL,
    competition_id INT(11) NOT NULL,
    round_id INT(11), 
    heat_id INT(11),
    result_type VARCHAR(50) NOT NULL,
    placement INT(11) NOT NULL,
    PRIMARY KEY (result_id),
    FOREIGN KEY (surfer_id) REFERENCES Surfers(surfer_id) ON DELETE CASCADE,
    FOREIGN KEY (heat_id) REFERENCES Heats(heat_id) ON DELETE CASCADE,
    FOREIGN KEY (round_id) REFERENCES Rounds(round_id) ON DELETE CASCADE,
    FOREIGN KEY (competition_id) REFERENCES Competitions(competition_id) ON DELETE CASCADE
);

-- The following are inserting sample data into each table according to Schema. All sample data for Surfers and Competitions (Dates excluded) came from https://www.worldsurfleague.com/
INSERT INTO Surfers (first_name,last_name,origin_country,age,world_rank)
VALUES 
("Griffin","Colapinto","United States",25,1),
("Jack","Robinson","Australia",26,2),
("John John","Florence","Hawaii",31,3),
("Ethan","Ewing","Australia",25,4),
("Jordy","Smith","South Africa",36,5);

INSERT INTO Competitions (competition_name,competition_location,competition_date) 
VALUES 
("Lexus Pipe Pro","Banzai Pipeline","2024/2/10"),
("Hurley Pro","Sunset Beach","2024-2-14"),
("MEO Rip Curl Pro","Supertubos","2024-2-18"),
("Rip Curl Pro","Bells Beach","2024-3-10"),
("Western Australia Margaret River Pro","Margaret River","2024-3-15");

-- Using SELECT subqueries for Rounds table insertions
INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Knockout"
FROM Competitions
WHERE competition_name = "Lexus Pipe Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Quarter-Final"
FROM Competitions
WHERE competition_name = "Lexus Pipe Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Semi-Final"
FROM Competitions
WHERE competition_name = "Lexus Pipe Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Final"
FROM Competitions
WHERE competition_name = "Lexus Pipe Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Knockout"
FROM Competitions
WHERE competition_name = "Hurley Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Quarter-Final"
FROM Competitions
WHERE competition_name = "Hurley Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Semi-Final"
FROM Competitions
WHERE competition_name = "Hurley Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Final"
FROM Competitions
WHERE competition_name = "Hurley Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Knockout"
FROM Competitions
WHERE competition_name = "MEO Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Quarter-Final"
FROM Competitions
WHERE competition_name = "MEO Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Semi-Final"
FROM Competitions
WHERE competition_name = "MEO Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Final"
FROM Competitions
WHERE competition_name = "MEO Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Knockout"
FROM Competitions
WHERE competition_name = "Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Quarter-Final"
FROM Competitions
WHERE competition_name = "Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Semi-Final"
FROM Competitions
WHERE competition_name = "Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Final"
FROM Competitions
WHERE competition_name = "Rip Curl Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Knockout"
FROM Competitions
WHERE competition_name = "Western Australia Margaret River Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Quarter-Final"
FROM Competitions
WHERE competition_name = "Western Australia Margaret River Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Semi-Final"
FROM Competitions
WHERE competition_name = "Western Australia Margaret River Pro";

INSERT INTO Rounds (competition_id, round_type)
SELECT competition_id, "Final"
FROM Competitions
WHERE competition_name = "Western Australia Margaret River Pro";

-- Using SELECT subqueries for Heats table insertions
INSERT INTO Heats (round_id, heat_number)
SELECT round_id, 1
FROM Rounds
WHERE round_type = "Knockout" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro");

INSERT INTO Heats (round_id, heat_number)
SELECT round_id, 1
FROM Rounds
WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro");

INSERT INTO Heats (round_id, heat_number)
SELECT round_id, 3
FROM Rounds
WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro");

INSERT INTO Heats (round_id, heat_number)
SELECT round_id, 4
FROM Rounds
WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro");

INSERT INTO Heats (round_id, heat_number)
SELECT round_id, 5
FROM Rounds
WHERE round_type = "Semi-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro");

-- Using SELECT subqueries for Heat_Scores table insertions
INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Griffin" AND last_name = "Colapinto"),
    (SELECT heat_id FROM Heats WHERE heat_number = 1 AND round_id = (SELECT round_id FROM Rounds WHERE round_type = "Knockout" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"))),
    19.95;

INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Jack" AND last_name = "Robinson"),
    (SELECT heat_id FROM Heats WHERE heat_number = 1 AND round_id = (SELECT round_id FROM Rounds WHERE round_type = "Knockout" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"))),
    18.00;

INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "John John" AND last_name = "Florence"),
    (SELECT heat_id FROM Heats WHERE heat_number = 1 AND round_id = (SELECT round_id FROM Rounds WHERE round_type = "Knockout" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"))),
    15.22;

INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Ethan" AND last_name = "Ewing"),
    (SELECT heat_id FROM Heats WHERE heat_number = 1 AND round_id = (SELECT round_id FROM Rounds WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"))),
    16.25;

INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Jordy" AND last_name = "Smith"),
    (SELECT heat_id FROM Heats WHERE heat_number = 1 AND round_id = (SELECT round_id FROM Rounds WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"))),
    12.11;

-- Using SELECT subqueries for Results table insertions
INSERT INTO Results (surfer_id, competition_id, round_id, heat_id, result_type, placement)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Griffin" AND last_name = "Colapinto"),
    (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"),
    NULL,
    NULL,
    "Competition",
    1;

INSERT INTO Results (surfer_id, competition_id, round_id, heat_id, result_type, placement)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Griffin" AND last_name = "Colapinto"),
    (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"),
    (SELECT round_id FROM Rounds WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro")),
    NULL,
    "Round",
    1;

INSERT INTO Results (surfer_id, competition_id, round_id, heat_id, result_type, placement)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Jack" AND last_name = "Robinson"),
    (SELECT competition_id FROM Competitions WHERE competition_name = "Hurley Pro"),
    (SELECT round_id FROM Rounds WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Hurley Pro")),
    (SELECT heat_id FROM Heats WHERE heat_number = 1 AND round_id = (SELECT round_id FROM Rounds WHERE round_type = "Quarter-Final" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "Lexus Pipe Pro"))),
    "Heat",
    2;

INSERT INTO Results (surfer_id, competition_id, round_id, heat_id, result_type, placement)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "John John" AND last_name = "Florence"),
    (SELECT competition_id FROM Competitions WHERE competition_name = "Rip Curl Pro"),
    NULL,
    NULL,
    "Competition",
    1;

INSERT INTO Results (surfer_id, competition_id, round_id, heat_id, result_type, placement)
SELECT 
    (SELECT surfer_id FROM Surfers WHERE first_name = "Ethan" AND last_name = "Ewing"),
    (SELECT competition_id FROM Competitions WHERE competition_name = "MEO Rip Curl Pro"),
    (SELECT round_id FROM Rounds WHERE round_type = "Knockout" AND competition_id = (SELECT competition_id FROM Competitions WHERE competition_name = "MEO Rip Curl Pro")),
    NULL,
    "Round",
    2;

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
