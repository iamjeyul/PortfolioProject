SELECT * FROM COVIDDEATHS
order by 3,4;

SELECT * FROM COVIDVACCINATIONS
order by 3,4;

select location, date, total_cases, new_cases, total_deaths, population from coviddeaths
order by 1,2;

-- looking at total cases vs total death
-- likeli hood of dying if you contract with covid in your contry
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage from coviddeaths
Where location like '%states%'
order by 1,2;

-- looking at total cases vs Population
-- shows percentage of people got covid
select location, date, total_cases, population, (total_cases/population)*100 as InfectionPercentage from coviddeaths
Where location like '%states%'
order by 1,2;

-- looking at contries with highest infection rate compare to population
select location, population, max(total_cases) as highestInfectioncount, max((total_cases/population))*100 as MaxInfectionPercentage from coviddeaths
group by location, population
order by 4 desc;

-- looking at Top 10
select top 10 location, population, max(total_cases) as highestInfectioncount, max((total_cases/population))*100 as MaxInfectionPercentage from coviddeaths
group by location, population
order by 4 desc;

-- looking at INDIA 
select location, population, max(total_cases) as highestInfectioncount, max((total_cases/population))*100 as MaxInfectionPercentage from coviddeaths
group by location, population
having location='INDIA'
order by 4 desc;

--- looking at contries with highest death count per population

select location, max(cast(total_deaths as int)) as Totaldeathcount from coviddeaths
Where continent is not null
group by location
order by Totaldeathcount desc;

---- let's break things by continent
---- continent with highest death count per population

select continent, max(cast(total_deaths as int)) as Totaldeathcount from coviddeaths
Where continent is not null
group by continent
order by Totaldeathcount desc;

--- Global numbers

select date, sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as Deathpercentage from coviddeaths
c
group by date
order by 1,2;

select sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_deaths, (sum(cast (new_deaths as int))/sum(new_cases))*100 as Deathpercentage from coviddeaths
Where continent is not null

-- looking at total population vs vaccination

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
inner join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
order by 2,3;

-- Using CTE

with popVSvac as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
inner join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
)

Select *, (RollingPeopleVaccinated/population)*100  from popVSvac

-- temp table

create table #PercentagePopulationVaccinated
(
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
);

insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
inner join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null

Select *, (RollingPeopleVaccinated/population)*100  from #PercentagePopulationVaccinated
order by 1,2,3;


--- creating view to store data for later visualization


create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from CovidDeaths dea
inner join CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null

select * from PercentagePopulationVaccinated;







