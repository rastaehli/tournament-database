-- Table definitions for the tournament project.

--psql commands to create the database and connect to it:
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

DROP TABLE IF EXISTS MATCH;
DROP TABLE IF EXISTS TOURNAMENT;
DROP TABLE IF EXISTS REGISTRATION;
DROP TABLE IF EXISTS PERSON;

CREATE TABLE TOURNAMENT(
	id SERIAL UNIQUE PRIMARY KEY,  -- GUID for this row
	name VARCHAR(128),	-- display name for this TOURNAMENT 
	round INTEGER);  -- identifies the current round to be played, NULL when done

CREATE TABLE PERSON(
	id SERIAL UNIQUE PRIMARY KEY,  -- GUID for this row
	name VARCHAR(128),  -- display name for this PERSON
	born TIMESTAMP);	-- date this person was born

CREATE TABLE REGISTRATION(
	id SERIAL UNIQUE PRIMARY KEY,  -- GUID for this row
	player INTEGER REFERENCES PERSON,  -- GUID for row in PERSON table - the person registered
	tournament INTEGER REFERENCES TOURNAMENT);	-- GUID for row in TOURNAMENT table - the tournament entered

CREATE TABLE MATCH(
	tournament INTEGER REFERENCES TOURNAMENT,	-- GUID for row in TOURNAMENT table
	round INTEGER,  -- identifies the tournament round this match belongs to
	p1 INTEGER REFERENCES REGISTRATION,  -- GUID for row in REGISTRATION table for player 1
	score1 INTEGER,  -- score for player 1 in this match, NULL until match ourcome recoreded
	p2 INTEGER REFERENCES REGISTRATION,  -- GUID for row in REGISTRATION table for player 2
	score2 INTEGER);  -- score for player 2 in this match, NULL until match ourcome recoreded

CREATE VIEW outcomes (tournament, round, player, win, match) AS 
    SELECT 
        tournament,
        round,
        p1 AS player, 
        CASE WHEN score1 > score2 THEN 1 ELSE 0 END, 
        1 
    FROM match
    UNION ALL
    SELECT 
        tournament,
        round,
        p2 AS player, 
        CASE WHEN score2 > score1 THEN 1 ELSE 0 END, 
        1 
    FROM match;

-- example use:
--
-- insert into tournament (name, round) values('test tournament',0);
-- insert into person (name,born) values('jan', '1959-01-08 00:00:00');
-- insert into person (name,born) values('richard', '1957-10-29 00:00:00');
-- insert into match values(0,0,0,null,1,null);
-- insert into registration (player,tournament) values(0,0);
-- insert into registration (player,tournament) values(1,0);
--
-- select t.name, t.round, p1.name, m.score1, p2.name, m.score2
-- 	from match m
-- 	join tournament t on m.tournament=t.id
-- 	join registration r1 on m.p1=r1.id
-- 	join person p1 on r1.player=p1.id
-- 	join registration r2 on m.p2=r2.id
-- 	join person p2 on r2.player=p2.id;
