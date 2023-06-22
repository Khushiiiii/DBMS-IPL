# Database Management System to store and manage data of the Indian Premier League
- February 2023 - April 2023
- We worked in a team of 4 people. I have worked on all the aspects of this project with my team members.


## Objective of the Project
We want to design and implement a database that handles the data of the Indian Premier League. Individual players profiles, data of matches, teams, sponsors, owners can be stored and viewed from this database. This database can be used by the IPL administration for various purposes like marketing, knowing individual player’s performance etc.
We should be able to get information such as the players of the teams, results of matches, wickets of particular teams/players, data about the coaches of the teams, who was the owner of the team, location of the stadium where the match was played, etc.

## Description of the Project

IPL is organized yearly in India where various cricket teams consisting of players from all over the world participate. IPL administration has to keep track of several things for the entire event organization. This information can be used by the advertisement companies, teams, coaches, sponsors etc for business evaluation, tracking past performance of players and teams etc. 

Each player has a unique player ID. Typically, a player can only be part of one team at a time. A player might change his team in another season of IPL. Seasons of IPL are basically the year in which it is organized. We record the name, age(birth date), nationality, speciality(batsman, bowler, all-rounder, etc), handedness of all the players. 

Often match records are kept to post them in the highlights of the website or show the statistics in the future matches to compare the teams and their players’ performances. For each match we record runs, wickets, etc of all the players. We also store the man of the match, location of the stadium, the name of the teams who played the match, the winning team, date of the match, name of the umpires, type of the match (league, semi-final, final) etc. 

For the stadiums, factors such as city, country, audience capacity, pitch conditions of the stadium are maintained in this database.

For each season of IPL, we store data of sponsors, list of teams, winning team, runners up team, man of the series. For each team, we record the details of the players, coaches, sponsors, owner, year, 
individual player prices, captain, etc.

We record the name, occupation/business, team, year of owning the team for all the owners. We store the name, field of work, team, year for all the sponsors. 

We keep the total runs, wickets, catches, strike rate, etc updated for all the players after the completion of a season.

## Contents:
* Entity Relationship Model 
* Relational Model
* Functional Dependancies
* Normalization to Boyce-Codd Normal Form (BCNF)
* DDL Script for Implementation of Relational Schema in PostgreSQL
* DML Script for Data Insertion Statements in PostgreSQL
* SQL sample queries

## What is next?
* Various external views can be added. This means that different types of users might see different subsets of database schema. The organizers of IPL can have access to all the data. However, different teams might see some subsets of the database since all the information can’t be shared with everyone. Same thing goes for users or audience of IPL.
* We can build a website, where the user can run queries on the databse. 
