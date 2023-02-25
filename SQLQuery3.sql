select location, date, total_cases, new_cases, total_deaths, population

from [portfolio 1]..CovidDeaths
where continent is not null
order by 1,2



select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
from [portfolio 1]..CovidDeaths
where location = 'Canada'
order by 1,2



select location, date, total_cases, population, (total_cases/population)*100 as Infection_Rate
from [portfolio 1]..CovidDeaths
where location = 'Canada'
order by 1,2






select location, MAX (total_cases) as Highest_Infection_Count, population, MAX((total_cases/population))*100 as Infection_Rate
from [portfolio 1]..CovidDeaths
--where location = 'Canada'

Group by location, population
order by Infection_Rate Desc






select location, MAX (cast(total_deaths as int)) as Highest_death_Count, population, MAX((total_deaths/population))*100 as Death_Rate
from [portfolio 1]..CovidDeaths
--where location = 'Canada'
where continent is not null
Group by location, population
order by Highest_death_Count Desc



select location, MAX (cast(total_deaths as int)) as Highest_death_Count_continents 
from [portfolio 1]..CovidDeaths
--where location = 'Canada'
where continent is null
Group by location
order by Highest_death_Count_continents  Desc



select date, sum(new_cases) as Total_Cases, SUM(cast(new_deaths as int)) as Total_deaths , SUM(cast(new_deaths as int)) / (SUM(New_Cases)*100) as DeathPercentage
from [portfolio 1]..CovidDeaths
where continent is not null and date > '2020-01-22 00:00:00.000'
Group by date
order by 1,2




select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated





from [portfolio 1]..CovidDeaths dea

join [portfolio 1]..CovidVaccinations vac
 on dea.location = vac.location 
 and dea.date = vac.date 
 where dea.continent is not null
 order by 2,3







 with PopulationvsVaccinations (Continent, Location, Date, Population, new_vaccinations, Rolling_People_Vaccinated)
 as 
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated


from [portfolio 1]..CovidDeaths dea
join [portfolio 1]..CovidVaccinations vac
 on dea.location = vac.location 
 and dea.date = vac.date 
 where dea.continent is not null

 )
 select *, ((Rolling_People_Vaccinated/population)*100) as VaccinationsPerPopulation
 from PopulationvsVaccinations



 Create View PercentPopulationVaccinated as

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated


from [portfolio 1]..CovidDeaths dea
join [portfolio 1]..CovidVaccinations vac
 on dea.location = vac.location 
 and dea.date = vac.date 
 where dea.continent is not null


 select *
 from PercentPopulationVaccinated
