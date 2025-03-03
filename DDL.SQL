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

INSERT INTO Rounds (competition_id,round_type) 
VALUES 
(1,"Knockout"),
(1,"Quarter-Final"),
(1,"Semi-Final"),
(1,"Final"),
(2,"Knockout"),
(2,"Quarter-Final"),
(2,"Semi-Final"),
(2,"Final"),
(3,"Knockout"),
(3,"Quarter-Final"),
(3,"Semi-Final"),
(3,"Final"),
(4,"Knockout"),
(4,"Quarter-Final"),
(4,"Semi-Final"),
(4,"Final"),
(5,"Knockout"),
(5,"Quarter-Final"),
(5,"Semi-Final"),
(5,"Final");

INSERT INTO Heats (round_id,heat_number) 
VALUES 
(1,1),
(2,1),
(2,3),
(2,4),
(3,5);

INSERT INTO Heat_Scores (surfer_id,heat_id,score_num) 
VALUES 
(1,1,19.95),
(2,1,18),
(3,1,15.22),
(4,2,16.25),
(5,2,12.11);

INSERT INTO Results (surfer_id,competition_id,round_id,heat_id,result_type,placement) 
VALUES 
(1,1,NULL,NULL,"Competition",1),
(1,1,2,NULL,"Round",1),
(2,2,2,1,"Heat",2),
(3,4,NULL,NULL,"Competition",1),
(4,3,1,NULL,"Round",2);

SET FOREIGN_KEY_CHECKS=1;
COMMIT;
