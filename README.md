# UEFA-Football-Data-Analysis-sql
This repository contains a comprehensive SQL-based analysis of UEFA competition data, focusing on teams, players, matches, goals, and stadiums. The project is designed to answer a series of specific, complex analytical questions using advanced SQL concepts, including joins, aggregations, subqueries, and window functions.

The analysis is based on five interconnected datasets that capture various aspects of European football dynamics.
______________________________________________________________________________________________________________________

**📂 Project Directory Tree** <br>
This structure organizes the raw data, the final analysis document, and the necessary SQL scripts.

uefa_football_analytics-sql/<br>
 |<br>
├── data/      #Stores the raw input CSV files for the five datasets <br>
│   ├── Goals.csv<br>
│   ├── Matches.csv<br>
│   ├── Players.csv<br>
│   ├── Stadiums.csv<br>
│   └── Teams.csv<br>
|<br>
├── sql/<br>
│   ├── schema_creation.sql #SQL script for creating the five relational tables.<br>
|   ├── view_created_table.sql #SQL script for viewing the five relational tables.<br> 
│   ├── Table_analysis.sql #Contains all the analytical SQL queries addressing table related project questions.<br>
|   ├── Cross-tab Analysis.sql #Contains all the analytical SQL queries addressing cross-table related project<br> 
|   |  questions.<br> 
|   └── Additional Complex Queries.sql #Contains all the SQL queries with window functions related project<br>
|       questions.<br>
|<br>
└── README.md<br>  #This overview document.

______________________________________________________________________________________________________________________

**🗃️ Datasets**<br>
The analysis utilizes the following five core datasets, which should be imported into a relational database (e.g., PostgreSQL, MySQL, SQLite).

- **Goals.csv**:	Detailed information on every goal scored, including scorer, assister, and match details.	_GOAL_ID, MATCH_ID, PLAYER_ID, DURATION, ASSIST, GOAL_DESC_
- **Matches.csv**:	Records of all matches played, including scores, attendance, and stadium.	_MATCH_ID, HOME_TEAM, AWAY_TEAM, STADIUM, , SEASON, DATE, HOME_TEAM_SCORE, AWAY_TEAM_SCORE, PENALTY_SHOOT_OUT, ATTENDANCE_
- **Players.csv**:	Biographical and positional data for all players.	_PLAYER_ID,FIRST_NAME, LAST_NAME, NATIONALITY, DOB, TEAM, JERSEY_NUMBER, POSITION, HEIGHT, WEIGHT, FOOT_
- **Stadiums.csv**:	Location and capacity details for all stadiums.	_NAME, COUNTRY, CITY, CAPACITY_
- **Teams.csv**:	Details for each team participating in the competitions.	_HOME_STADIUM, TEAM_NAME, COUNTRY_

______________________________________________________________________________________________________________________


**🚀 Getting Started**<br>
1. Database Setup
- _Import Data:_ Load the five .csv files from the data/ directory into your chosen SQL database (PostgreSQL is recommended).
- _Schema Creation:_ Run the DDL (Data Definition Language) script found in sql/schema_creation.sql to define the tables and establish the necessary Primary Key and Foreign Key constraints based on the Data Dictionary.

2. Running the Analysis
Rest all the file in sql contains the full set of queries developed for this project.

Key types of analyses include:

- Match Performance: Calculating home/away team win distributions by country.
- Player Statistics: Identifying top goal scorers, best assisters, and analyzing goals scored by player position (e.g., defenders).
- Stadium & Attendance Impact: Analyzing goal scoring patterns in high-attendance matches or large-capacity stadiums.
- Complex Metrics: Calculating metrics like the average score difference, or the ratio of goals scored in the first 30 minutes of a match.




