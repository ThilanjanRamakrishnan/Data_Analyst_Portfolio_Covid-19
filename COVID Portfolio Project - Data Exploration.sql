/*
Covid 19 Data Exploration 
Skills used: WITH clause, Temp Tables, Aggregate Functions, Creating Views
*/

Select * 
From covid_data
where continent <> ''


-- Show total case vs total deaths vs case fatality rate for each country

SELECT location, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as case_fatality_rate
FROM covid_data
where continent <> ''
group by location
order by sum(new_cases) desc

-- Show the percentage of the population infected with Covid for each country

SELECT location, sum(new_cases) as total_cases, population, (sum(new_cases)/population) * 100 as infected_percentage
FROM covid_data
where continent <> ''
group by location, population
order by sum(new_cases) desc

-- Based on the population checking the vaccinated percentage 

with t1 as (Select location, people_fully_vaccinated, population
			From covid_data
			where continent <> '' and people_fully_vaccinated <> 0
            order by location, people_fully_vaccinated desc),
	 t2 as (select location, max(people_fully_vaccinated) as people_fully_vaccinated, (max(people_fully_vaccinated)/population)*100 as vaccinated_percentage
            from t1
            group by location, population
			)
select *
from t2

-- Getting the global summary for total cases, total death, death percentage, total vaccinated population and total vaccinated percentage

with t1 as (Select location, people_fully_vaccinated, population
			From covid_data
			where continent <> '' and people_fully_vaccinated <> 0
            order by location, people_fully_vaccinated desc),
	 t2 as (select location, max(people_fully_vaccinated) as people_fully_vaccinated, (max(people_fully_vaccinated)/population)*100 as vaccinated_percentage
            from t1
            group by location, population),
	 t3 as (select sum(t2.people_fully_vaccinated) total_vaccinated_people
			from t2),
	 t4 as (Select sum(new_cases) total_cases, sum(new_deaths) total_deaths, (sum(new_deaths)/sum(new_cases)) death_percentage
			From covid_data
			where continent <> ''),
	 t5 as (Select sum(population) total_population
			from (Select distinct location, population
			from covid_data
			where continent <> '')x)
	
SELECT t4.total_cases, t4.total_deaths, t4.death_percentage, t3.total_vaccinated_people, (t3.total_vaccinated_people/t5.total_population)*100 as vaccinated_percentage
from t4, t3, t5

