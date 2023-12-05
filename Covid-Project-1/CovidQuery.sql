Select *
From PortfolioProjects..CovidVaccinations$
ORDER BY 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjects..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
From PortfolioProjects..CovidDeaths$
WHERE Location like '%states%'
ORDER BY 1,2


-- Total Cases vs Population
-- Shows what percentage of population got Covid

Select Location, date, total_cases, Population, (CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) * 100 AS PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2


-- Countries with Highest Infextion Rate compared to Population

Select Location, Population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
From PortfolioProjects..CovidDeaths$
WHERE continent is not null
GROUP BY Location, Population
ORDER BY PercentPopulationinfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths AS bigint)) AS TotalDeathCount
From PortfolioProjects..CovidDeaths$
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount desc


-- Continent with Highest Death Count per Population

Select continent, MAX(cast(total_deaths AS bigint)) AS TotalDeathCount
FROM PortfolioProjects..CovidDeaths$
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount desc


-- GLOBAL NUMBERS

Select date, SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/ NULLIF(SUM(new_cases), 0)*100 AS Deathpercentage
From PortfolioProjects..CovidDeaths$
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

Select SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/ NULLIF(SUM(new_cases), 0)*100 AS Deathpercentage
From PortfolioProjects..CovidDeaths$
WHERE continent is not null
ORDER BY 1,2


-- Total Populaiton vs Vaccinations (PopvsVac)
-- Use CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingVaccinationCount)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
FROM PortfolioProjects..CovidDeaths$ dea
JOIN PortfolioProjects..CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
)
Select *, (RollingVaccinationCount / population) * 100 AS RollingVaccinationPercent
FROM PopvsVac
