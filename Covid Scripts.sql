SELECT *
FROM CovidDeaths
WHERE continent <> '' 
ORDER BY 3,4

-- global numbers
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
From CovidDeaths
WHERE NOT (location LIKE '%income' or location = 'world')
AND continent <> '' 
-- Group By date
order by 1,2

-- Total deaths,total cases and populatioin in the U.S.
SELECT date, total_deaths, total_cases, population
FROM CovidDeaths
WHERE location = 'united states'
AND continent <> '' 
ORDER BY date
 
 -- the percentage of death within the total cases
 -- shows the likelihood of dying if you contract covid in the U.S.
Select SUM(new_deaths) as total_deaths, SUM(new_cases) as total_cases, SUM(new_deaths)/SUM(new_cases)*100 as death_percentage
From CovidDeaths
WHERE location = 'united states'
AND continent <> '' 
-- Group By date
order by 1,2

 
 -- total cases vs. population
 -- shows the percentage of population got covid
SELECT location, date, population, total_cases, (total_cases/population)*100 as infected_rate
FROM CovidDeaths
WHERE location = 'united states'
AND continent <> '' 
ORDER BY 1,2
 
 -- Countries with Highest Infection Rate compared to Population
SELECT location, population, Max(total_cases) AS Total_cases, MAX((total_cases/population))*100 as infected_rate
FROM CovidDeaths
WHERE continent <> '' 
GROUP BY location, population
ORDER BY infected_rate DESC
 
 -- Countries with Highest Death Count per Population
SELECT location, Max(total_deaths) AS total_death_count
FROM CovidDeaths
WHERE continent <> '' 
GROUP BY location
ORDER BY total_death_count DESC
 
-- Continent with Highest Death Count per Population
SELECT location, Max(total_deaths) AS Total_Death_Count
FROM CovidDeaths
WHERE continent = '' 
AND NOT (location LIKE '%income' or location = 'world')
GROUP BY location
ORDER BY total_death_count DESC

-- Total Population vs. Vaccinations
-- CREATE CTE
WITH pop_vaccinations AS (
    SELECT
        CD.continent,
        CD.location,
        CD.date,
        CD.population,
        NULLIF(CV.new_vaccinations, '') AS new_vaccinations,
        SUM(NULLIF(CV.new_vaccinations, '')) OVER (PARTITION BY CD.location ORDER BY CD.location, CD.date) AS rolling_vaccinated
    FROM CovidDeaths CD
    JOIN CovidVaccinations CV ON CD.location = CV.location AND CD.date = CV.date
    WHERE CD.continent <> ''
)
SELECT *,
       (rolling_vaccinated / population) * 100 AS vaccination_percentage
FROM pop_vaccinations


