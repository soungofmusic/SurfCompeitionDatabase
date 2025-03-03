-- Authors: Alan Massey, Spencer Oung

-- Surfers
-- SELECT all surfers
SELECT * FROM Surfers;

-- Get all Surfer IDs and Names to populate the Surfer page
SELECT surfer_id, first_name, last_name FROM Surfers;

-- INSERT a new surfer
INSERT INTO Surfers (first_name, last_name, origin_country, age, world_rank)
VALUES (:first_name_input, :last_name_input, :origin_country_input, :age_input, :world_rank_input);

-- UPDATE a surfer's details
UPDATE Surfers
SET first_name = :first_name_input,
    last_name = :last_name_input,
    origin_country = :origin_country_input,
    age = :age_input,
    world_rank = :world_rank_input
WHERE surfer_id = :surfer_id_input;

-- DELETE a surfer
DELETE FROM Surfers WHERE surfer_id = :surfer_id_input;

-- Competitions
-- SELECT all competitions
SELECT * FROM Competitions;

-- Get all competitions and their location for the List Competitions page
SELECT competition_id, competition_name, competition_location, competition_date
FROM Competitions;

-- Get a single competition's data for the Update Competition form
SELECT competition_id, competition_name, competition_location, competition_date
FROM Competitions
WHERE competition_id = :competition_ID_selected_from_browse_competition_page;

-- INSERT a new competition
INSERT INTO Competitions (competition_name, competition_location, competition_date)
VALUES (:competition_name_input, :competition_location_input, :competition_date_input);

-- UPDATE a competition's details
UPDATE Competitions
SET competition_name = :competition_name_input,
    competition_location = :competition_location_input,
    competition_date = :competition_date_input
WHERE competition_id = :competition_id_input;

-- Delete a competition
DELETE FROM Competitions
WHERE competition_id = :competition_ID_selected_from_browse_competition_page;

-- Rounds
-- SELECT all rounds
SELECT * FROM Rounds;

-- SELECT all rounds with competition name
SELECT Rounds.round_id, Competitions.competition_name, Rounds.round_type FROM Rounds INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id;


-- INSERT a new round
INSERT INTO Rounds (competition_id, round_type)
VALUES (:competition_id_input, :round_type_input);

-- UPDATE a round's details
UPDATE Rounds
SET competition_id = :competition_id_input,
    round_type = :round_type_input
WHERE round_id = :round_id_input;

-- DELETE a round
DELETE FROM Rounds WHERE round_id = :round_id_input;

-- Heats
-- SELECT all heats
SELECT * FROM Heats;

-- SELECT all heats with competition name, round type, and heat number
SELECT Heats.heat_id, Competitions.competition_name, Rounds.round_type, Heats.heat_number
FROM Heats
INNER JOIN Rounds ON Heats.round_id = Rounds.round_id
INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id;

-- Get all heats for associating with surfers
SELECT heat_id, 'Heat ' || heat_number AS heat_name
FROM Heats;

-- INSERT a new heat
INSERT INTO Heats (round_id, heat_number)
VALUES (:round_id_input, :heat_number_input);

-- UPDATE a heat's details
UPDATE Heats
SET round_id = :round_id_input,
    heat_number = :heat_number_input
WHERE heat_id = :heat_id_input;

-- DELETE a heat
DELETE FROM Heats WHERE heat_id = :heat_id_input;

-- Heat_Scores
-- SELECT all heat scores
SELECT * FROM Heat_Scores;

-- SELECT all heat scores with surfer name, competition name, round type, heat number, and score
SELECT Heat_Scores.score_id, Surfers.first_name, Surfers.last_name, Competitions.competition_name, Rounds.round_type, Heats.heat_number, Heat_Scores.score_num
FROM Surfers
INNER JOIN Heat_Scores ON Surfers.surfer_id = Heat_Scores.surfer_id
INNER JOIN Heats ON Heat_Scores.heat_id = Heats.heat_id
INNER JOIN Rounds ON Heats.round_id = Rounds.round_id
INNER JOIN Competitions ON Rounds.competition_id = Competitions.competition_id
ORDER BY Heat_Scores.score_id ASC;

-- Get all surfers with their current associated heats and scores
SELECT Surfers.surfer_id, Surfers.first_name, Surfers.last_name,
      Heats.heat_id, 'Heat ' || Heats.heat_number AS heat_name,
      Heat_Scores.score_num AS score
FROM Surfers
INNER JOIN Heat_Scores ON Surfers.surfer_id = Heat_Scores.surfer_id
INNER JOIN Heats ON Heat_Scores.heat_id = Heats.heat_id
ORDER BY Surfers.last_name, Surfers.first_name, Heats.heat_number;

-- INSERT a new heat score
INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
VALUES (:surfer_id_input, :heat_id_input, :score_num_input);

-- Associate a surfer with a heat (M-to-M relationship addition)
INSERT INTO Heat_Scores (surfer_id, heat_id, score_num)
VALUES (:surfer_id_from_dropdown_input, :heat_id_from_dropdown_input, :score_num_input);

-- UPDATE a heat score
UPDATE Heat_Scores
SET surfer_id = :surfer_id_input,
    heat_id = :heat_id_input,
    score_num = :score_num_input
WHERE score_id = :score_id_input;

-- DELETE a heat score
DELETE FROM Heat_Scores WHERE score_id = :score_id_input;

-- Dis-associate a surfer from a heat (M-to-M relationship deletion)
DELETE FROM Heat_Scores
WHERE surfer_id = :surfer_ID_selected_from_heat_and_surfer_list
  AND heat_id = :heat_ID_selected_from_heat_and_surfer_list;

-- Results
-- SELECT all results
SELECT * FROM Results;

-- SELECT all results with surfer name, competition name, round type, heat number, result type, and placement
SELECT Results.result_id, Surfers.first_name, Surfers.last_name, Competitions.competition_name, Rounds.round_type, Heats.heat_number, Results.result_type, placement
FROM Results
INNER JOIN Surfers ON Results.surfer_id = Surfers.surfer_id
INNER JOIN Competitions ON Results.competition_id = Competitions.competition_id
LEFT JOIN Rounds ON Results.round_id = Rounds.round_id
LEFT JOIN Heats ON Results.heat_id = Heats.heat_id
ORDER BY Results.result_id ASC;

-- INSERT a new result
INSERT INTO Results (surfer_id, competition_id, round_id, heat_id, result_type, placement)
VALUES (:surfer_id_input, :competition_id_input, :round_id_input, :heat_id_input, :result_type_input, :placement_input);

-- UPDATE a result
UPDATE Results
SET surfer_id = :surfer_id_input,
    competition_id = :competition_id_input,
    round_id = :round_id_input,
    heat_id = :heat_id_input,
    result_type = :result_type_input,
    placement = :placement_input
WHERE result_id = :result_id_input;

-- DELETE a result
DELETE FROM Results WHERE result_id = :result_id_input;
