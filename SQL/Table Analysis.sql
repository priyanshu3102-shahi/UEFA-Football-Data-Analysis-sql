--Goal Analysis (From the Goals table)
--1.	Which player scored the most goals in a each season?
SELECT p.player_id, p.first_name, p.last_name, m.season, COUNT(*) AS goals_scored
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
JOIN matches AS m ON g.match_id = m.match_id
GROUP BY p.player_id, p.first_name, p.last_name, m.season
ORDER BY m.season, goals_scored DESC;

--2.	How many goals did each player score in a given season?
SELECT p.player_id, p.first_name || ' ' || p.last_name AS player_name, m.season,
COUNT(*) AS total_goals
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
JOIN matches AS m ON g.match_id = m.match_id
GROUP BY p.player_id, player_name, m.season
ORDER BY m.season, total_goals DESC;

--3.	What is the total number of goals scored in ‘mt403’ match?
SELECT COUNT(*) AS total_goals
FROM goals WHERE match_id = 'mt403';

--4.	Which player assisted the most goals in a each season?
SELECT season, player_name, max(total_assists) AS max_assists
FROM (
    SELECT m.season, a.player_id, a.first_name || ' ' || a.last_name AS player_name,
    COUNT(*) AS total_assists
    FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id
    JOIN players AS a ON g.assist = a.player_id
    GROUP BY m.season, a.player_id, player_name
) AS sub
GROUP BY season, player_name
ORDER BY season;

--5.	Which players have scored goals in more than 10 matches?
SELECT p.player_id, p.first_name || ' ' || p.last_name AS player_name,
COUNT(DISTINCT g.match_id) AS matches_scored
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
GROUP BY p.player_id, player_name
HAVING COUNT(DISTINCT g.match_id) > 10
ORDER BY matches_scored DESC;

--6.	What is the average number of goals scored per match in a given season?
SELECT season, ROUND(COUNT(goal_id) * 1.0 / COUNT(DISTINCT match_id), 2) AS average_goals
FROM matches LEFT JOIN goals USING (match_id)
GROUP BY season ORDER BY season;

--7.	Which player has the most goals in a single match?
SELECT p.first_name || ' ' || p.last_name AS player_name, g.match_id,
COUNT(*) AS goals_in_match
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
GROUP BY g.match_id, p.player_id, player_name
ORDER BY goals_in_match DESC
LIMIT 1;

--8.	Which team scored the most goals in the all seasons?
SELECT p.team AS team_name, COUNT(*) AS total_goals
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
GROUP BY p.team ORDER BY total_goals DESC
LIMIT 1;

--9.	Which stadium hosted the most goals scored in a single season?
SELECT m.stadium, m.season, COUNT(g.goal_id) AS total_goals
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id
GROUP BY m.stadium, m.season ORDER BY total_goals DESC
LIMIT 1;






--Match Analysis (From the Matches table)
--10.	What was the highest-scoring match in a particular season?
SELECT match_id, home_team, away_team, home_team_score, away_team_score,
(home_team_score + away_team_score) AS total_goals
FROM matches WHERE season = '2021-2022'
ORDER BY total_goals DESC
LIMIT 1;

--11.	How many matches ended in a draw in a given season?
SELECT COUNT(*) AS draw_matches
FROM matches
WHERE season = '2021-2022' AND home_team_score = away_team_score;

--12.	Which team had the highest average score (home and away) in the season 2021-2022?
SELECT team, ROUND(AVG(score), 2) AS avg_score
FROM (
    SELECT home_team AS team, home_team_score AS score FROM matches WHERE season = '2021-2022'
    UNION ALL
    SELECT away_team AS team, away_team_score AS score FROM matches WHERE season = '2021-2022'
) AS all_scores
GROUP BY team ORDER BY avg_score DESC
LIMIT 1;

--13.	How many penalty shootouts occurred in a each season?
SELECT season,COUNT(match_id) AS total_shootouts
FROM matches
WHERE penalty_shoot_out=1
GROUP BY season
ORDER BY season;
--THERE IS NO PENALTY SHOOTOUTS

--14.	What is the average attendance for home teams in the 2021-2022 season?
SELECT ROUND(AVG(attendance), 0) AS avg_home_attendance
FROM matches
WHERE season = '2021-2022';

--15.	Which stadium hosted the most matches in a each season?
SELECT season, stadium, COUNT(*) AS match_count
FROM matches GROUP BY season, stadium
ORDER BY season, match_count DESC;

--16.	What is the distribution of matches played in different countries in a season?
SELECT s.country, COUNT(*) AS match_count
FROM matches AS m JOIN stadiums AS s ON m.stadium = s.name
WHERE m.season = '2021-2022'
GROUP BY s.country
ORDER BY match_count DESC;

--17.	What was the most common result in matches (home win, away win, draw)?
SELECT result_type, COUNT(*) AS match_count
FROM (SELECT 
        CASE 
            WHEN home_team_score > away_team_score THEN 'Home Win'
            WHEN home_team_score < away_team_score THEN 'Away Win'
            ELSE 'Draw'
        END AS result_type
    FROM matches
) AS results
GROUP BY result_type ORDER BY match_count DESC;




--Player Analysis (From the Players table)
--18.	Which players have the highest total goals scored (including assists)?
SELECT p.player_id, p.first_name || ' ' || p.last_name AS player_name,
  COUNT(*) AS total_contributions
FROM players AS p JOIN goals AS g ON p.player_id = g.pid OR p.player_id = g.assist
GROUP BY p.player_id, player_name
ORDER BY total_contributions DESC;

--19.	What is the average height and weight of players per position?
SELECT position, AVG(height) AS avg_height_cm, AVG(weight) AS avg_weight_kg
FROM players GROUP BY position ORDER BY position;

--20.	Which player has the most goals scored with their left foot?
SELECT p.player_id, p.first_name || ' ' || p.last_name AS player_name, COUNT(*) AS left_foot_goals
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
WHERE LOWER(g.goal_desc) LIKE '%left%'
GROUP BY p.player_id, player_name
ORDER BY left_foot_goals DESC LIMIT 1;

--21.	What is the average age of players per team?
SELECT team, ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, dob))), 2) AS avg_age
FROM players GROUP BY team ORDER BY avg_age DESC;

--22.	How many players are listed as playing for a each team in a season?
SELECT team, COUNT(*) AS total_players
FROM players GROUP BY team
ORDER BY total_players DESC;

--23.	Which player has played in the most matches in the each season?
SELECT m.season, p.player_id, p.first_name || ' ' || p.last_name AS player_name,
  COUNT(DISTINCT g.match_id) AS matches_played
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id JOIN players AS p ON g.pid = p.player_id
GROUP BY m.season, p.player_id, player_name
ORDER BY m.season, matches_played DESC;

--24.	What is the most common position for players across all teams?
SELECT position, COUNT(*) AS position_count
FROM players GROUP BY position
ORDER BY position_count DESC
LIMIT 5;

--25.	Which players have never scored a goal?
SELECT p.player_id, p.first_name || ' ' || p.last_name AS player_name
FROM players AS p LEFT JOIN goals g ON p.player_id = g.pid
WHERE g.goal_id IS NULL;





--Team Analysis (From the Teams table)
--26.	Which team has the largest home stadium in terms of capacity?
SELECT t.team_name,s.name AS stadium_name,s.capacity
FROM teams AS t JOIN stadiums AS s ON t.home_stadium = s.name
ORDER BY s.capacity DESC
LIMIT 5;

--27.	Which teams from a each country participated in the UEFA competition in a season?
SELECT DISTINCT t.country, m.season, t.team_name
FROM matches AS m JOIN teams AS t ON t.team_name = m.home_team OR t.team_name = m.away_team
ORDER BY t.country, m.season, t.team_name;


--28.	Which team scored the most goals across home and away matches in a given season?
SELECT team, SUM(score) AS total_goals
FROM (
    SELECT home_team AS team, home_team_score AS score
    FROM matches WHERE season = '2021-2022'
    UNION ALL
    SELECT away_team AS team, away_team_score AS score
    FROM matches WHERE season = '2021-2022'
) AS combined_score
GROUP BY team
ORDER BY total_goals DESC
LIMIT 5;

--29.	How many teams have home stadiums in a each city or country?
SELECT s.country, s.city, COUNT(DISTINCT t.team_name) AS team_count
FROM teams AS t JOIN stadiums AS s ON t.home_stadium = s.name
GROUP BY s.city, s.country
ORDER BY team_count DESC;

--30.	Which teams had the most home wins in the 2021-2022 season?
SELECT home_team,COUNT(*) AS home_wins
FROM matches WHERE season = '2021-2022' AND home_team_score > away_team_score
GROUP BY home_team ORDER BY home_wins DESC;



--Stadium Analysis (From the Stadiums table)
--31.	Which stadium has the highest capacity?
SELECT name AS stadium_name,capacity
FROM stadiums ORDER BY capacity DESC
LIMIT 1;

--32.	How many stadiums are located in a ‘Russia’ country or ‘London’ city?
SELECT COUNT(*) AS total_stadiums
FROM stadiums WHERE LOWER(country) = 'russia' OR LOWER(city) = 'london';

--33.	Which stadium hosted the most matches during a season?
SELECT season, stadium, COUNT(*) AS match_count
FROM matches GROUP BY season, stadium
ORDER BY match_count DESC LIMIT 1;

--34.	What is the average stadium capacity for teams participating in a each season?
SELECT  m.season, ROUND(AVG(s.capacity), 0) AS avg_stadium_capacity
FROM matches AS m JOIN teams AS t ON t.team_name = m.home_team 
JOIN stadiums AS s ON s.name = t.home_stadium
GROUP BY m.season ORDER BY m.season;

--35.	How many teams play in stadiums with a capacity of more than 50,000?
SELECT COUNT(DISTINCT t.team_name) AS teams_over_50000
FROM teams AS t JOIN stadiums AS s ON t.home_stadium = s.name
WHERE s.capacity > 50000;

--36.	Which stadium had the highest attendance on average during a season?
SELECT season, stadium, ROUND(AVG(attendance), 0) AS avg_attendance
FROM matches GROUP BY 1,2
ORDER BY avg_attendance DESC
LIMIT 5;

--37.	What is the distribution of stadium capacities by country?
SELECT  country, COUNT(*) AS stadium_count, ROUND(AVG(capacity), 0) AS avg_capacity
FROM stadiums GROUP BY country ORDER BY stadium_count DESC;

