select * from CovidDeaths ORDER BY 3,4 where continent is not null

select * from CovidVaccinations ORDER BY 3,4


select location,date,total_cases,new_cases,total_deaths,population from CovidDeaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathperc from CovidDeaths ORDER BY 1,2
--Total death perc each country and date wise
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathperc from CovidDeaths where location 
like '%united%' 
ORDER BY 1,2

--Total population vs death
select location,date,total_cases,total_deaths,population,(total_cases/population)*100 as populationvscasesperc from CovidDeaths where location 
like '%united%' 
ORDER BY 1,2

--Looking at countries with highest infection rate compared to population

select location,population,max(total_cases) as maxcases,max(total_cases/population)*100 as infectedrate from CovidDeaths 
GROUP BY location,population
ORDER BY 1,2

--Showing countries with highest death count per population
select location,max(cast(total_deaths as int)) as toatldeath from CovidDeaths
where continent is not null
Group by location
ORDER BY toatldeath DESC

--Showing the above one based on continent

select continent,max(cast(total_deaths as int)) as total_death from CovidDeaths
where continent is not null
Group by continent
ORDER BY total_death DESC

--Global numbers

select date,sum(new_cases),sum(cast(new_deaths as int)) as new_death,sum(cast(new_deaths as int))/sum(new_cases)*100 as deathperc from CovidDeaths
where continent is not null
Group by date
order by deathperc DESC

--Looking at total population vs vaccination
select dea.date,dea.continent,dea.location,vac.new_vaccinations from CovidDeaths dea
join CovidVaccinations vac on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
ORDER BY 4 DESC

--sum of vaccination based on each location

select dea.date,dea.continent,dea.location,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
ORDER BY 2,3

--With CTE
with popvsvacc (date,continent,location,new_vaccination,rollingpeople)
as (
select dea.date,dea.continent,dea.location,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null
)

select * from popvsvacc



--Creating view

drop view if exists vu_coronadata
create view vu_coronadata  as
select dea.date,dea.continent,dea.location,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from CovidDeaths dea
join CovidVaccinations vac on dea.date=vac.date and dea.location=vac.location
where dea.continent is not null



