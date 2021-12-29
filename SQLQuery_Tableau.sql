--1)
select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from MinorProject..covid_Deaths
where continent is not null
order by 1,2


--2)
select location,sum(cast(new_deaths as int)) as totalDeathCount
from MinorProject..covid_Deaths
where continent is null
and location not in('World','European Union','International','Upper middle income','High income','Low income','Lower middle income')
group by location
order by totalDeathCount desc


--3)
select location,population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
from MinorProject..covid_Deaths
group by location,population
order by PercentPopulationInfected desc

--4)
select location,population,date,max(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentPopulationInfected
from MinorProject..covid_Deaths
group by location,population,date
order by PercentPopulationInfected desc


--5)
Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From MinorProject..covid_Deaths dea
Join MinorProject..covid_Vaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2,3


--6) covid vaccinations + booster shots

select dea.continent,dea.location,dea.date,dea.population,vac.people_fully_vaccinated,max(vac.total_boosters) as total_boosters
from MinorProject..covid_Deaths dea
join MinorProject..covid_Vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null 
and total_boosters is not null
group by dea.continent,dea.location,dea.date,dea.population,vac.people_fully_vaccinated




--7) People Fully Vaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.people_fully_vaccinated
from MinorProject..covid_Deaths dea
join MinorProject..covid_Vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
and people_fully_vaccinated is not null
group by dea.continent,dea.location,dea.date,dea.population,vac.people_fully_vaccinated

