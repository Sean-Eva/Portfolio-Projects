-- Tableau Table 1

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProjects..CovidDeaths$
where continent is not null 
order by 1,2


-- Tableau Table 2

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProjects..CovidDeaths$
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc


-- Tableau Table 3

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
Group by Location, Population
order by PercentPopulationInfected desc


-- Tableau Table 4

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
Group by Location, Population, date
order by PercentPopulationInfected desc