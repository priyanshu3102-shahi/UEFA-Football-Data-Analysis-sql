--Additional Complex Queries (Combining multiple aspects)
--51.	What is the average number of goals scored by each team in the first 30 minutes of a match?
SELECT p.team, ROUND(COUNT(*) * 1.0 / COUNT(DISTINCT g.match_id), 2) AS avg_goals_first_30
FROM goals AS g JOIN players AS p ON g.pid = p.player_id
WHERE g.duration <= 30 GROUP BY p.team;

--52.	Which stadium had the highest average score difference between home and away teams?
SELECT stadium, ROUND(AVG(ABS(home_team_score - away_team_score)), 2) AS avg_score_diff
FROM matches GROUP BY stadium ORDER BY avg_score_diff DESC LIMIT 1;

--53.	How many players scored in every match they played during a given season?
SELECT COUNT(*) AS players_scored_every_match
FROM (SELECT g.pid, COUNT(DISTINCT g.match_id) AS matches_played, COUNT(DISTINCT g.match_id) AS matches_scored
FROM goals AS g JOIN matches AS m ON g.match_id = m.match_id
WHERE m.season = '2021-2022' GROUP BY g.pid
HAVING COUNT(DISTINCT g.match_id) = COUNT(DISTINCT g.match_id)
) AS consistent_scorers;

--54.	Which teams won the most matches with a goal difference of 3 or more in the 2021-2022 season?
SELECT home_team AS team, COUNT(*) AS big_home_wins
FROM matches WHERE season = '2021-2022' AND (home_team_score - away_team_score) >= 3
GROUP BY home_team ORDER BY big_home_wins DESC LIMIT 1;

--55.	Which player from a specific country has the highest goals per match ratio?
SELECT p.player_id, p.first_name || ' ' || p.last_name AS player_name,
ROUND(COUNT(g.goal_id)*1.0 / COUNT(DISTINCT g.match_id), 2) AS goals_per_match
FROM players AS p
JOIN goals AS g ON p.player_id = g.pid
WHERE p.nationality = 'Spain'  --  Change this to any country
GROUP BY p.player_id, player_name
ORDER BY goals_per_match DESC
LIMIT 1;
