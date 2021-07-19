SELECT *
FROM Portfolio_Project.dbo.CovidDeaths
WHERE continent IS NOT NULL
Order By 3, 4

--SELECT *
--FROM Portfolio_Project.dbo.CovidVaccinations
--Order By 3, 4


SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM Portfolio_Project.dbo.CovidDeaths
Order By 1, 2

-- Looking at Total cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM Portfolio_Project.dbo.CovidDeaths
WHERE location like '%India%'
Order By 1, 2

--Looking at the Total cases vs population 
-- Shows the percentage of the population infected by Covid

SELECT Location, date, population, total_cases,(total_cases/population)*100 AS PopulationInfected
FROM Portfolio_Project.dbo.CovidDeaths
WHERE location like '%India%'
Order By 1, 2

--Looking at Countries with the Hightest infection rates compared the population

SELECT Location, population, MAX (total_cases) AS HightestInfectionCount, MAX((total_cases/population)*100) AS PercentPopulationInfected
FROM Portfolio_Project.dbo.CovidDeaths
--WHERE location like '%India%'
GROUP BY Location, population
Order By PercentPopulationInfected DESC

--Showing the countries with the highest death count per Population

SELECT Location, MAX(Cast(total_deaths as INT)) AS TotalDeathCount
FROM Portfolio_Project.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC

--Showing the continent with the highest death count per population 

SELECT continent, MAX(Cast(total_deaths as INT)) AS TotalDeathCount
FROM Portfolio_Project.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM Portfolio_Project.dbo.CovidDeaths
--WHERE location LIKE '%states%'
WHERE  continent IS NOT NULL
ORDER BY 1,2

-- Looking at total Population and Vaccination

 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
 FROM Portfolio_Project.dbo.CovidDeaths AS dea
 JOIN  Portfolio_Project.dbo.CovidVaccinations AS vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL
	ORDER BY 1, 2, 3



-- Use CTE
WITH Popvsvac (Continent, Location, Date, Population, New_Vaccincations, RollingVaccinationCount)
AS(
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
 FROM Portfolio_Project.dbo.CovidDeaths AS dea
 JOIN  Portfolio_Project.dbo.CovidVaccinations AS vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL)
	--ORDER BY 1, 2, 3 )

SELECT *, (RollingVaccinationCount/Population)*100
FROM Popvsvac


--Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent NVARCHAR(255),
Location NVARCHAR(255),
Date DATETIME, 
Population Numeric,
New_Vaccinations Numeric,
RollingVaccinationCount Numeric
)

INSERT INTO #PercentPopulationVaccinated

 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
 FROM Portfolio_Project.dbo.CovidDeaths AS dea
 JOIN  Portfolio_Project.dbo.CovidVaccinations AS vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingVaccinationCount / Population)*100
FROM #PercentPopulationVaccinated

--Creating view for visualization

CREATE VIEW PercentPopulationVaccinated AS 
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
 SUM(CAST(vac.new_vaccinations AS INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingVaccinationCount
 FROM Portfolio_Project.dbo.CovidDeaths AS dea
 JOIN  Portfolio_Project.dbo.CovidVaccinations AS vac
	ON dea.location=vac.location
	AND dea.date=vac.date
WHERE dea.continent IS NOT NULL


SELECT *
FROM PercentPopulationVaccinated

CREATE VIEW TotalDeathCount AS
SELECT Location, MAX(Cast(total_deaths as INT)) AS TotalDeathCount
FROM Portfolio_Project.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
--ORDER BY TotalDeathCount DESC

CREATE VIEW InfectionCount AS
SELECT Location, population, MAX (total_cases) AS HightestInfectionCount, MAX((total_cases/population)*100) AS PercentPopulationInfected
FROM Portfolio_Project.dbo.CovidDeaths
--WHERE location like '%India%'
GROUP BY Location, population
--Order By PercentPopulationInfected DESC