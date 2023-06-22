
--Queries 


--1. List of all the players who have been participating in the IPL in the past years/particular year

--All the years:
SELECT playerid, "Name" FROM players;

--Particular years:
SELECT playerid, "Name" FROM 
players NATURAL JOIN YearWisePlayerDetails 
WHERE "Year" = 2019;


--2. List of all the players who have participated from the same team in all the seasons of IPL

SELECT distinct playerid,  teamid, "Name" FROM 
(SELECT count(distinct teamid),playerid FROM yearwiseplayerdetails
 GROUP BY playerid HAVING count(distinct teamid) = 1 ) AS r2
 	NATURAL JOIN yearwiseplayerdetails
NATURAL JOIN players as r1;


--3. The champions of a particular year/all the years 

--All the Years:
SELECT "Year", championteam, teamname FROM ipl JOIN teams on championteam = teamid;

--Particular Year
SELECT "Year", championteam, teamname FROM ipl JOIN teams on championteam = teamid WHERE "Year" = 2022;



--4. The winning teams in all the matches played during an IPL season

SELECT * FROM
(SELECT matchid, matchtype, teamid AS winning_team FROM "Match" NATURAL JOIN played 
WHERE extract(year FROM "Date") = 2015 and winner='1') AS r1
NATURAL JOIN 
(SELECT matchid, matchtype, teamid as losing_team FROM "Match" NATURAL JOIN played WHERE 
extract(year FROM "Date") = 2015 and winner='0') AS r2;


--5. The details about the man of the match of a particular match/ of all the matches

--All the matches:
SELECT * FROM 
(SELECT matchid,  m.manofthematch , pl."Name", y.teamid, p.teamid as team1 FROM 
played as p NATURAL JOIN "Match" as m 
JOIN YearWisePlayerDetails as y on m.manofthematch = y.playerid and extract(year FROM m."Date") = y."Year" 
NATURAL JOIN players as pl WHERE p.winner = '1') as r1
NATURAL JOIN
(SELECT matchid,  m.manofthematch , pl."Name", y.teamid, p.teamid as team2 FROM
played as p NATURAL JOIN "Match" as m 
JOIN YearWisePlayerDetails as y on m.manofthematch = y.playerid and extract(year FROM m."Date") = y."Year" 
NATURAL JOIN players as pl WHERE p.winner = '0') as r2

--Particular match 
SELECT * FROM 
(SELECT matchid,  m.manofthematch , pl."Name", y.teamid, p.teamid as team1 FROM
played as p NATURAL JOIN "Match" as m 
JOIN YearWisePlayerDetails as y on m.manofthematch = y.playerid and extract(year FROM m."Date") = y."Year" 
NATURAL JOIN players as pl WHERE p.winner = '1' and (p.teamid = 'CSK' or p.teamid = 'RCB') and y."Year" = 2015) as r1
NATURAL JOIN
(SELECT matchid,  m.manofthematch , pl."Name", y.teamid, p.teamid as team2 FROM
played as p NATURAL JOIN "Match" as m 
JOIN YearWisePlayerDetails as y on m.manofthematch = y.playerid and extract(year FROM m."Date") = y."Year" 
NATURAL JOIN players as pl WHERE p.winner = '0' and (p.teamid = 'CSK' or p.teamid = 'RCB') and y."Year" = 2015) as r2


--6. The details of the coaches for any particular year/any particular team

--Particular Year
SELECT "Year", CoachID, CoachName, Teamid FROM headcoach NATURAL JOIN teamdetails WHERE "Year" = 2019;

--Particular Team 
SELECT  Teamid,"Year", CoachID, CoachName FROM headcoach NATURAL JOIN teamdetails WHERE teamid = 'CSK';

 
--7. The details of the sponsor of the IPL during a specific year/all the years

--Particular year
SELECT "Year", teamid, sponsorCompany,businessdomain,country 
FROM teamdetails AS td JOIN Titlesponsor AS t ON td.sponsorcompany=t.companyname WHERE "Year" = 2019;

--All the years
SELECT "Year", teamid, sponsorCompany,businessdomain,country 
FROM teamdetails AS td JOIN Titlesponsor AS t ON td.sponsorcompany=t.companyname;

--Particular Team 
SELECT "Year", teamid, sponsorCompany,businessdomain,country 
FROM teamdetails AS td JOIN Titlesponsor AS t ON td.sponsorcompany=t.companyname WHERE teamid = 'MI';
	

--8. Details of Owner Company of a particular team

SELECT teamid,o.* FROM TeamOwner as o JOIN Teams 
on o.companyname = teams.ownercompany WHERE TeamID = 'CSK';
   

--9. Give details of the sponsor of a particular team in a particular year

SELECT teamid, "Year",CompanyName, businessdomain, Country FROM TitleSponsor as s JOIN teamdetails as t 
on s.companyname = t.sponsorcompany
WHERE TeamID = 'RCB' AND "Year" = 2019;


--10. All the information of any particular player like his age, DOB, country, his speciality, etc.

SELECT * FROM Players WHERE "Name" = 'Hardik Pandya';
	
	
--11. The details(runs, wickets) of any particular player for a particular season


--For a particular season
	
SELECT "Name", TotalWickets, TotalRuns FROM YearwisePlayerDetails NATURAL JOIN Players WHERE PlayerID = '00012' and "Year" = 2019;
	



--12. Give details of a player with his performance stats over the years

SELECT playerid, "Name", "Total Wickets Taken", "Total Runs", MostWicketTaken, strikerate FROM 
(SELECT PlayerID, sum(TotalWickets) as "Total Wickets Taken", sum(TotalRuns) as "Total Runs", max(MaximumWickets) as MostWicketTaken FROM YearwisePlayerDetails WHERE PlayerID = '00012' GROUP BY PlayerID) as r1
NATURAL JOIN players as p;


--13. The details about all the stadiums where IPL has been conducted or played before.

SELECT DISTINCT s.* FROM Stadium AS s NATURAL JOIN "Match" AS m; 


--14. List the total number of matches played in a particular stadium.

SELECT StadiumName, City, COUNT(MatchID) AS "Number of matches played"
FROM "Match" Group BY StadiumName,City;


--15. List the total number of different teams handled by a particular coach over all the seasons.

SELECT CoachID, Coachname, "No. of Teams Handled" 
FROM (SELECT coachID, count(DISTINCT TeamID) AS "No. of Teams Handled" FROM TeamDetails GROUP BY CoachID) AS r NATURAL JOIN Headcoach AS h;


--16. List the name of teams sponsored by a particular sponsor over all the seasons{Display Company name, name of the team and year in which the company sponsored that team}.

SELECT SponsorCompany, "Year", TeamID FROM TeamDetails WHERE SponsorCompany = 'Royal Stag';

--17. Give yearwise budget spent by teams on player purchase.

SELECT teamid, "Year", (sum(playerprice)/10000000) AS "Budger Spent to buy Players(in Crores)" FROM YearWisePlayerDetails GROUP BY Teamid, "Year" ORDER BY "Year";


--18. Total budget spent in the IPL seasons

SELECT "Year", SUM("Budger Spent to buy Players") AS "Total Budget Spent" FROM (SELECT "Year", sum(playerprice) AS "Budger Spent to buy Players"
FROM YearWisePlayerDetails GROUP BY "Year" 
UNION 
SELECT EXTRACT(YEAR FROM "Date") AS "Year", SUM(RentAmount) 
FROM "Match" AS m 
NATURAL JOIN STADIUM AS s GROUP BY EXTRACT(YEAR FROM "Date") ) AS r 
GROUP BY "Year";


--19. Generate winning statistics of a team (how many matches did a particular team win throughout the season).

SELECT TeamID, "Year", COUNT(winner)  FROM 
(SELECT td.teamid, td."Year",winner FROM TeamDetails AS td LEFT JOIN 
	((SELECT MatchID, EXTRACT(YEAR FROM "Date") AS "Year" 
	FROM "Match" AS m) AS r 
NATURAL JOIN (SELECT * FROM Played AS p
WHERE p.winner='1') AS t) ON td.teamid=t.teamid AND td."Year"=r."Year") as rel 
	GROUP BY TeamID, "Year" ORDER BY "Year";



--20. Generate coaching statistics of a coach over the past five years (the number of times his team won the IPL) 

SELECT CoachID, CoachName, Years_of_Experience, "No. of times his team won IPL match" FROM HeadCoach AS h 
NATURAL JOIN (SELECT CoachID, COUNT(Winner) AS "No. of times his team won IPL match" FROM TeamDetails AS td 
NATURAL JOIN (SELECT TeamID, EXTRACT(YEAR FROM "Date") AS "Year", Winner FROM "Match" AS m NATURAL JOIN PLAYED AS p WHERE Winner='1') AS r2
GROUP BY CoachID) AS r;


--21. Who is the coach whose team won the maximum number of times?

SELECT CoachID, CoachName, Years_of_Experience, "No. of times his team won the IPL"
FROM HeadCoach AS h NATURAL JOIN
(SELECT CoachID, COUNT(Winner) AS "No. of times his team won the IPL" 
FROM TeamDetails AS td NATURAL JOIN 
(SELECT TeamID, EXTRACT(YEAR FROM "Date") AS "Year", Winner
FROM "Match" AS m NATURAL JOIN PLAYED AS p WHERE Winner='1') AS r2
GROUP BY CoachID) AS r 
ORDER BY "No. of times his team won the IPL" DESC LIMIT 2;


--22.  List the details of the player who has earned the title of “Man of the match” for more than once during a particular year (2019) of IPL
	
SELECT p.* FROM players as p JOIN 
(SELECT ManOfTheMatch FROM "Match" 
WHERE extract(year FROM "Date")=2019 
group by ManOfTheMatch having count(ManOfTheMatch)>1) as r1
on manofthematch = playerid;


--23. List the details of the player who has earned the title of "Man of the match" in multiple seasons of the IPL.


SELECT p.* FROM players AS p JOIN 
(SELECT COUNT(DISTINCT EXTRACT(YEAR FROM "Date")),manofthematch FROM "Match" 
GROUP BY manofthematch HAVING COUNT(DISTINCT EXTRACT(YEAR FROM "Date"))>1)AS r 
ON playerid=manofthematch;


--24. List the teams who reached the finals maximum number of times

SELECT teamid, count(teamid) as No_of_times_team_reached_finals FROM 
played NATURAL JOIN "Match" WHERE matchtype = 'Final'
GROUP BY teamid ORDER BY No_of_times_team_reached_finals DESC LIMIT 1;


--25. List of coaches who have mentored winning/champion teams of the IPL

SELECT championteam as WinnerTeam, ipl."Year", headcoach.coachid, coachname FROM ipl JOIN teamdetails 
on championteam = teamid and ipl."Year" = teamdetails."Year"
JOIN headcoach on headcoach.coachid = teamdetails.coachid;


--26. List of coaches who have mentored runners-up teams of the IPL
SELECT teamid, "Year", coachid, coachname FROM 
(SELECT teamid, extract(year FROM "Date") as "Year" FROM 
"Match" NATURAL JOIN played WHERE winner='0' and matchtype = 'Final') as r
NATURAL JOIN teamdetails
NATURAL JOIN headcoach;



--27. List the players who has best bowling statistics in a particular season / who deserves the purple cap in a particular season .
--Judge the players on the basis of maximum wickets, if same, check who gave minimum runs. 

SELECT * FROM  
(SELECT playerid, "Year" , teamid, maximumwickets, maximumwicketsruns FROM yearwiseplayerdetails
WHERE "Year" = 2015 and maximumwickets is not null
order by maximumwickets desc) as r1
JOIN 
(SELECT max(maximumwickets) FROM yearwiseplayerdetails
WHERE "Year" = 2015 and maximumwickets is not null) as r2
on r1.maximumwickets = r2.max
order by maximumwicketsruns limit 1;


--28. List the players who scored most runs in particular season

SELECT * FROM  
(SELECT playerid, "Year" , teamid, maximumruns, out_notout FROM yearwiseplayerdetails
WHERE "Year" = 2022 and maximumruns is not null
order by maximumruns desc) as r1
JOIN 
(SELECT max(maximumruns) FROM yearwiseplayerdetails
WHERE "Year" = 2022 and maximumruns is not null) as r2
on r1.maximumruns = r2.max
order by out_notout desc limit 1;


--29. count of total wickets taken by all the bowlers

SELECT SUM(TotalWickets) FROM yearwiseplayerdetails NATURAL JOIN players 
WHERE "Role" = 'Bowler'; 


--30. List all the umpires who worked in finals of the ipl 

SELECT u.*, EXTRACT(YEAR FROM "Match"."Date") as year FROM "Match" NATURAL JOIN UmpiredBy NATURAL JOIN Umpire as u
WHERE MatchType = 'Final';

--31. A team who won all the matches played by it during a particular season

SELECT DISTINCT TeamID,EXTRACT(YEAR FROM "Date")
FROM "Match" AS m NATURAL JOIN Played AS p 
	WHERE EXTRACT(YEAR FROM "Date")='2019' AND p.winner='1'
EXCEPT
SELECT DISTINCT TeamID,EXTRACT(YEAR FROM "Date") FROM "Match" AS m NATURAL JOIN Played AS p 
	WHERE EXTRACT(YEAR FROM "Date")='2019' AND p.winner='0';
