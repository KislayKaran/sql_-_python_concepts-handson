Select *
From PortfolioProject.dbo.CovidDeaths
order by 3,4

--Select *
--From PortfolioProject.dbo.CovidVaccinations
--order by 3,4


Select Location,date,total_cases,new_cases,total_deaths,population
From PortfolioProject..CovidDeaths
order by 1,2

--Looking at total_cases Vs total_deaths  i.e. Death_Percentage
--Likelihood of dying if you contract with covid in your country

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
order by 1,2

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where Location='India'
order by 1,2

--Looking at total_cases Vs Population
--Shows what percentage got covid 

Select Location,date,population,total_cases,(total_cases/population)*100 as ppln_prcnt_got_Covid
From PortfolioProject..CovidDeaths
order by 1,2

Select Location,date,population,total_cases,(total_cases/population)*100 as ppln_prcnt_got_Covid
From PortfolioProject..CovidDeaths
Where Location='India'
order by 1,2

--Looking at countries with highest infection rates compares to their population

Select Location,population,Max(total_cases) as highest_infection_count,Max((total_cases/population)*100) as percent_ppln_infected
From PortfolioProject..CovidDeaths
group by Location,population 
order by 4 desc

--Showing Countries with Highest Death Counts
Select Location,Max(cast(total_deaths as int)) as total_death_counts
From PortfolioProject..CovidDeaths
where continent is not null
group by Location
order by 2 desc

--Break it down by Continents
Select continent, MAX(cast(total_deaths as int)) as total_death_counts
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by 2 desc

--To check whether the values obtained above are correct or not

Select continent, MAX(cast(total_deaths as int)) as total_death_counts
From PortfolioProject..CovidDeaths
Where continent = 'Asia'
group by Location

Select Location,date, cast(new_deaths as int) as new_death_counts,
SUM(CONVERT(int,new_deaths))  OVER (Partition by Location Order by Location,date) as total_death_count
From PortfolioProject..CovidDeaths
Where continent = 'Asia'
group by Location

Select Location,date, cast(new_deaths as int) as new_death_counts,
SUM(CONVERT(int,new_deaths))  OVER (Partition by Location Order by Location,date) as total_death_count
From PortfolioProject..CovidDeaths
Where continent = 'Asia'
group by Location

Select Location, MAX(cast(total_deaths as int)) as total_death_counts,
SUM(total_death_counts)  OVER (Partition by Location Order by Location,date) as Roll_death_count
From PortfolioProject..CovidDeaths
Where continent = 'Asia'
group by Location
order by 2 desc

--Global Data of new cases and new deaths on daily basis

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Daily_DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
group by date
order by 1,2

--Total covid cases and covid deaths till April 05 2022

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Daily_DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2



Select *
From PortfolioProject..CovidVaccinations
order by 3,4

--Joining 2 tables

Select *
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date

--Looking at total populations Vs vaccinations

Select d.continent,d.location,d.date,d.population,v.new_vaccinations
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
order by 2,3

--vaccination getting on the daily basis

Select d.continent,d.location,d.date,d.population, v.new_vaccinations,
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.Location Order by d.Location,d.date) as Rolling_people_vaccinated
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
order by 2,3


--Using CTE


With PopvsVac (continent,Location,date,population,new_vaccinations,Rolling_people_vaccinated)
as
(
Select d.continent,d.location,d.date,d.population, v.new_vaccinations,
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.Location Order by d.Location,d.date) as Rolling_people_vaccinated
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
--order by 2,3
)
Select *,(Rolling_people_vaccinated/population)*100 as Percent_Population_Vaccinated
From PopVsVac


--Using Temporary Table 
--(entire cmnd of temp table can be executed only once, for multiple execution use drop cmnd before)

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
Rolling_people_vaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select d.continent,d.location,d.date,d.population, v.new_vaccinations,
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.Location Order by d.Location,d.date) as Rolling_people_vaccinated
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
order by 2,3
Select *,(Rolling_people_vaccinated/population)*100 as Percent_Population_Vaccinated
From #PercentPopulationVaccinated

--Creating a View
Drop View PopulationVaccinated
Create View PopulationVaccinated as 
Select d.continent,d.location,d.date,d.population,v.new_vaccinations
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
--order by 2,3

Select *
From PopulationVaccinated
Where continent is not null
Order by 1,2

SELECT 
  TABLE_SCHEMA,
  TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS

SELECT 
  SCHEMA_NAME(schema_id) AS [Schema],
  Name
FROM sys.views
