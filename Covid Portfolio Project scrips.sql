--- COVID PORTFOLIO PROJECT

-- Analysing the Data
Select * 
From PortfolioProject..CovidVaccinations$

Select * 
From PortfolioProject..CovidDeaths

--Selecting Data that are going to used for the Project 

Select Location,date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths
order by 1,2;

-- Looking at Total cases vs Total Deaths
-- Shows the likelihood of one dying if you contract covid in your country 
Select Location,date, total_cases,total_deaths, (total_deaths/total_cases)* 100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like 'Germany' and continent is not null
order by 1,2;


-- Looking at the Total cases vs Population
-- Shows what percentage of population got Covid in a given country 

Select Location,date, total_cases,population, (total_cases/population)* 100 as percent_of_population_infected
From PortfolioProject..CovidDeaths
Where location like 'Germany' and continent is not null
order by 1,2;


-- Loking at countries with highest infection rate compared to population

Select Location,population, max(total_cases) as highest_infection_count, max((total_cases/population))* 100 as 
percent_of_population_infected
From PortfolioProject..CovidDeaths
where continent is not null
group by location,population 
order by percent_of_population_infected desc;


-- Showing Countries with Highest death Count per population 

Select Location, max(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
where continent is not null
group by location 
order by total_death_count desc;


--Breaking things by continent

Select continent, max(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
where continent is not null
group by continent 
order by total_death_count desc;


-- Showing continents with the highest death count per population

Select continent, max(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
where continent is not null
group by continent 
order by total_death_count desc;


-- Global Numbers per day

Select date, sum(new_cases) as total_case, sum(cast(new_deaths as int)) as total_death, 
(sum(cast(new_deaths as int))/sum(new_cases)) * 100 as death_percentage 
From PortfolioProject..CovidDeaths 
where continent is not null
Group by date
order by 1,2;

-- Overall Global Numbers 

Select sum(new_cases) as total_case, sum(cast(new_deaths as int)) as total_death, 
(sum(cast(new_deaths as int))/sum(new_cases)) * 100 as death_percentage 
From PortfolioProject..CovidDeaths 
where continent is not null
order by 1,2;


-- looking at total Population vs vacinnations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--(rolling_people_vaccinated) * 100 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3;




-- Using  CTE 

with PopvsVac (continent,location,date, population,new_vaccination, rolling_people_vaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--(rolling_people_vaccinated) * 100 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , (rolling_people_vaccinated/population)*100
from PopvsVac;



-- Using Temp Table

drop table  if exists #Percent_Population_vaccinated
Create table #Percent_Population_vaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

insert into #Percent_Population_vaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--(rolling_people_vaccinated) * 100 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select * , (rolling_people_vaccinated/population)*100
from #Percent_Population_vaccinated;


-- Creating views to store data for later visualization 

create view Percent_Population_vaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rolling_people_vaccinated
--(rolling_people_vaccinated) * 100 
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

drop view Percent_Population_vaccinated

select * from Percent_Population_vaccinated