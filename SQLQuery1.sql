select * 
from MinorProject..covid_Deaths
where continent is not null
order by 3,4

--select * 
--from MinorProject..covid_Vaccinations
--order by 3,4

select Location, date, total_cases,new_cases,total_deaths,population
from MinorProject..covid_Deaths
order by 1,2

--looking at total cases VS total deaths

select Location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from MinorProject..covid_Deaths
where location like '%india%'
order by 1,2


--looking at total cases VS Population

select Location, date,population,total_cases,(total_cases/population)*100 as PercentageAffectedINDIA
from MinorProject..covid_Deaths
where location like '%india%'
order by 1,2

--looking at countries with high infection rate VS population

select location,population,MAX(total_cases) as HighestCount,MAX((total_cases/population))*100 as PercentageInfected
from MinorProject..covid_Deaths
--where location like '%india%'
group by location,population
order by PercentageInfected desc

--looking at countries with highest death percentage per population

select location,MAX(cast(total_deaths as int)) as TotalDeaths
from MinorProject..covid_Deaths
--where location like '%india%'
where continent is not null
group by location
order by TotalDeaths desc


--looking at continents


--continents with highest death count

select continent,MAX(cast(total_deaths as int)) as TotalDeaths
from MinorProject..covid_Deaths
--where location like '%india%'
where continent is not null
group by continent
order by TotalDeaths desc


--global numbers

select date, SUM(new_cases) as total_Cases, SUM(cast(new_deaths as int)) as total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100
as DeathPercentage
from MinorProject..covid_Deaths
where continent is not null
group by date
order by 1,2

--TOTAL CASES IN THE WHOLE WORLD AS OF 25/12/2021

select SUM(new_cases) as total_Cases, SUM(cast(new_deaths as int)) as total_Deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100
as DeathPercentage
from MinorProject..covid_Deaths
where continent is not null
--group by date
order by 1,2


--looking at total population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine


select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location,dea.date) as
RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from MinorProject..covid_Deaths dea
join MinorProject..covid_Vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3



--USING CTE

with popVsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location,dea.date) as
RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from MinorProject..covid_Deaths dea
join MinorProject..covid_Vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from popVsVac



--USING TEMP TABLE


drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date dateTime,
population float,
new_vaccinations nvarchar(255),
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location,dea.date) as
RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from MinorProject..covid_Deaths dea
join MinorProject..covid_Vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *,(RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated



--creating views to store data for further visualization

drop View PercentPopulationVaccinated
Create View PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) OVER (PARTITION by dea.location order by dea.location,dea.date) as
RollingPeopleVaccinated
--,(RollingPeopleVaccinated/population)*100
from MinorProject..covid_Deaths dea
join MinorProject..covid_Vaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3