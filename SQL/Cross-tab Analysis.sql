--Cross-Table Analysis (Combining multiple tables)
--38.	Which players scored the most goals in matches held at a specific stadium?
SELECT p.first_name || ' ' || p.last_name AS player_name, g.match_id, COUNT(*) AS goals
FROM goals AS g JOIN players AS p ON g.pid = p.player_id JOIN matches AS m ON g.match_id = m.match_id
WHERE m.stadium = 'Jan Breydel Stadion'  -- replace with desired stadium
GROUP BY player_name, g.match_id ORDER BY goals DESC
LIMIT 5;

--39.	Which team won the most home matches in the season 2021-2022 (based on match scores)?
SELECT home_team, COUNT(*) AS home_wins
FROM matches WHERE season = '2021-2022' AND home_team_score > away_team_score
GROUP BY home_team ORDER BY home_wins DESC
LIMIT 1;

--40.	Which players played for a team that scored the most goals in the 2021-2022 season?
SELECT player_id, first_name, last_name FROM players
WHERE team = ( SELECT team FROM (
    SELECT home_team AS team, home_team_score AS score FROM matches WHERE season = '2021-2022'
    UNION ALL
    SELECT away_team AS team, away_team_score AS score FROM matches WHERE season = '2021-2022'
  ) AS all_goals
  GROUP BY team ORDER BY SUM(score) DESC LIMIT 1);



--41.	How many goals were scored by home teams in matches where the attendance was above 50,000?
SELECT SUM(home_team_score) AS goals
FROM matches WHERE attendance > 50000;

/*42.	Which players played in matches where the score difference (home team score - away team score)
was the highest?*/
SELECT DISTINCT p.player_id, p.first_name, p.last_name
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
WHERE g.match_id = (SELECT match_id FROM matches
ORDER BY ABS(home_team_score - away_team_score) DESC LIMIT 1);


--43.	How many goals did players score in matches that ended in penalty shootouts?
SELECT COUNT(*) AS total_goals
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id
WHERE m.penalty_shoot_out = 1;

--44.	What is the distribution of home team wins vs away team wins by country for all seasons?
SELECT country, win_result, COUNT(*) AS match_count
FROM (SELECT s.country,
    CASE 
      WHEN m.home_team_score > m.away_team_score THEN 'Home Win'
      WHEN m.home_team_score < m.away_team_score THEN 'Away Win'
      ELSE 'Draw'
    END AS win_result
  FROM matches AS m
  JOIN stadiums AS s ON m.stadium = s.name
) AS results
GROUP BY country, win_result
ORDER BY country, win_result;


--45.	Which team scored the most goals in the highest-attended matches?
SELECT p.team, COUNT(*) AS total_goals
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
WHERE g.match_id = (SELECT match_id FROM matches ORDER BY attendance DESC LIMIT 1)
GROUP BY p.team ORDER BY total_goals DESC LIMIT 1;


--46.	Which players assisted the most goals in matches where their team lost(you can include 3)?
SELECT p.first_name || ' ' || p.last_name AS player_name, COUNT(*) AS total_assists
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id JOIN players AS p ON g.assist = p.player_id
WHERE (
  (p.team = m.home_team AND m.home_team_score < m.away_team_score)
  OR
  (p.team = m.away_team AND m.away_team_score < m.home_team_score)
)
GROUP BY player_name ORDER BY total_assists DESC LIMIT 3;

--47.	What is the total number of goals scored by players who are positioned as defenders?
SELECT COUNT(*) AS total_goals
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
WHERE LOWER(p.position) = 'defender';

--48.	Which players scored goals in matches that were held in stadiums with a capacity over 60,000?
SELECT DISTINCT p.player_id, p.first_name, p.last_name
FROM goals as g JOIN matches AS m ON g.match_id = m.match_id JOIN stadiums AS s ON m.stadium = s.name
JOIN players AS p ON g.pid = p.player_id
WHERE s.capacity > 60000;

--49.	How many goals were scored in matches played in cities with specific stadiums in a season?
SELECT m.season, s.city, COUNT(*) AS total_goals
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id JOIN stadiums AS s ON m.stadium = s.name
GROUP BY m.season, s.city ORDER BY m.season, total_goals DESC;

--50.	Which players scored goals in matches with the highest attendance (over 100,000)?
SELECT DISTINCT p.player_id, p.first_name, p.last_name
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id JOIN players AS p ON g.pid = p.player_id
WHERE m.attendance > 100000;
--there is no attendance over 100,000
SELECT *
FROM matches
ORDER BY attendance DESC
LIMIT 1;
