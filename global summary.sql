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
			where continent <> '' and location <> 'United Kingdom')x)
	
		
            
SELECT t4.total_cases, t4.total_deaths, t4.death_percentage, t3.total_vaccinated_people, (t3.total_vaccinated_people/t5.total_population)*100 as vaccinated_percentage
from t4, t3, t5
