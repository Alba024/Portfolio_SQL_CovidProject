
Select *
From [Portfolio-Project]..covid_deaths
order by 3,4

--Select *
--From [Portfolio-Project]..[Covid-Vaccinations]
--order by 3,4


-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population_density
From [Portfolio-Project]..covid_deaths
Order by 1,2


--Looking at Total Cases vs Total Deaths

Select Location, date, total_cases, total_deaths, 
       CAST(total_deaths AS float) / NULLIF(CAST(total_cases AS float), 0)*100 AS death_rate   
FROM [Portfolio-Project]..covid_deaths
ORDER BY 1,2

--Note: We use CAST to convert varchar dates to numeric dates.
--      We use NULLIF to avoid that SQL make a division for zero, so it is replaced for NULL, otherwase it gonna be a error.

--A other example for total cases vs total deaths at a specific country.

Select Location, date, total_cases, total_deaths, 
       CAST(total_deaths AS float) / NULLIF(CAST(total_cases AS float), 0)*100 AS death_rate   
FROM [Portfolio-Project]..covid_deaths
Where location like 'Spain'
ORDER BY 1,2


-- Looking at Total Cases vs Population

Select Location, date,  population_density, total_cases,
       CAST(total_cases AS float) / NULLIF(CAST(population_density AS float), 0)*100 AS polulation_infected   
FROM [Portfolio-Project]..covid_deaths
--Where location like 'Spain'
ORDER BY 1,2


-- Looking at Countries with Highest Infection Rate compared to Polulation

Select Location, population_density, MAX(total_cases) AS HighestInfectionCount,
      MAX(CAST(total_cases AS float) / NULLIF(CAST(population_density AS float), 0))*100 AS Infection_rate   
FROM [Portfolio-Project]..covid_deaths
GROUP BY Location, population_density -- Al utilizar la función de agregación MAX, se utiliza la cláusula GROUP BY para indicar cómo deben agruparse los datos en Location y Population.
ORDER BY Infection_rate desc



-- Showing countries with Highest Death Count per Population

Select Location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio-Project]..covid_deaths
Where continent is not null
Group by Location
Order by TotalDeathCount desc


--Let's break things down by continent

-- Showing continents with the highest death count per population

Select continent, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio-Project]..covid_deaths
Where continent is not null
Group by continent
Order by TotalDeathCount desc

---
Select location, MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM [Portfolio-Project]..covid_deaths
Where continent is null
Group by location
Order by TotalDeathCount desc



--GLOBAL NUMBERS <DATE>

Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
  (new_deaths as int))/NULLIF(SUM(new_cases), 0)*100 as Deathpercentage
FROM [Portfolio-Project]..covid_deaths
Where continent is not null
Group By date
ORDER BY 1,2

--GLOBAL NUMBERS <WITHOUT DATE>

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
  (new_deaths as int))/NULLIF(SUM(new_cases), 0)*100 as Deathpercentage
FROM [Portfolio-Project]..covid_deaths
Where continent is not null
ORDER BY 1,2





