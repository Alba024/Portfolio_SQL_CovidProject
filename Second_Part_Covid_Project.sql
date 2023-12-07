
---Covid Vaccination Table

--Select *
--From [Portfolio-Project]..[Covid-Vaccinations]


-- Loooking t Total Population vs Vaccinations

Select *
From [Portfolio-Project]..[covid_deaths] dea
Join [Portfolio-Project].. [Covid-Vaccinations]vac
    On dea.location = vac.location
	and dea.date = vac.date


Select  dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
From [Portfolio-Project]..[covid_deaths] dea
Join [Portfolio-Project].. [Covid-Vaccinations]vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- OVER PARTITION BY

Select  dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
SUM(CAST(ISNULL(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.Location Order by dea.location, -- We use ISNULL / BIGINT to extralonger numbers
dea.Date) as RollingPeopleVaccinated 
From [Portfolio-Project]..[covid_deaths] dea
Join [Portfolio-Project].. [Covid-Vaccinations]vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, Location, Date, population_density, new_vaccinations, RollingPeopleVaccinated) --Here the column names have to be the same of the columns names specificated below
as
(
Select  dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
SUM(CAST(ISNULL(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.Location Order by dea.location, -- We use ISNULL / BIGINT to extralonger numbers
dea.Date) as RollingPeopleVaccinated 
From [Portfolio-Project]..[covid_deaths] dea
Join [Portfolio-Project].. [Covid-Vaccinations]vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *
From PopvsVac


-- OR

--Select *, (RollingPeopleVaccinated/Population_density)*100
--From PopvsVac




--TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccination numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select  dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
SUM(CAST(ISNULL(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.Location Order by dea.location, -- We use ISNULL / BIGINT to extralonger numbers
dea.Date) as RollingPeopleVaccinated 
From [Portfolio-Project]..[covid_deaths] dea
Join [Portfolio-Project].. [Covid-Vaccinations]vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *,
    CASE -- We use CASE to indicated some execution conditions and avoid errors, for example divisions by zero
	    WHEN Population = 0 OR Population IS NULL THEN 0
		ELSE (RollingPeopleVaccinated/Population)*100
    END AS PercentageVaccinated
From #PercentPopulationVaccinated




--Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select  dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations,
SUM(CAST(ISNULL(vac.new_vaccinations, 0) as bigint)) OVER (Partition by dea.Location Order by dea.location, -- We use ISNULL / BIGINT to extralonger numbers
dea.Date) as RollingPeopleVaccinated 
From [Portfolio-Project]..[covid_deaths] dea
Join [Portfolio-Project].. [Covid-Vaccinations]vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3 -- The ORDER BY clause is invalid in views.

--------------

Select * FROM INFORMATION_SCHEMA.VIEWS ---- This queyris is to founding where was stored the table view in case you don't found it at the first time in the View file.


Select*
FROM PercentPopulationVaccinated