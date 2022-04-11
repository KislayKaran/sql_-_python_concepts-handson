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

--Hospital and ICU Admissions on daily basis 

Select Location,date,population,
(convert(int,hosp_patients)) as Currently_hospital_patients ,
(convert(int,hosp_patients)) - LAG(convert(int,hosp_patients))
    OVER (ORDER BY date ) as hospital_in_out,
(convert(int,icu_patients)) as Currently_patients_in_icu,
(convert(int,icu_patients)) - LAG(convert(int,icu_patients))
    OVER (ORDER BY date ) as icu_in_out,
(convert(int,new_deaths)) as new_deaths_each_day,
(convert(int,total_deaths)) as total_deaths
From PortfolioProject..CovidDeaths
Where Location='United States' and hosp_patients is not null
order by 2


Select continent,Location,date,population,
hosp_patients as Currently_hospital_patients ,
icu_patients as Currently_patients_in_icu,
(cast(icu_patients as float))/(cast(hosp_patients as float))*100 as icu_admnPercentage,
(convert(int,new_deaths)) as new_deaths_each_day,
(convert(int,total_deaths)) as total_deaths
From PortfolioProject..CovidDeaths
Where  location='United States' and continent is not null and hosp_patients is not null and icu_patients is not null
order by 2,3


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

Select continent, SUM(cast(new_deaths as int)) as total_death_counts
From PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by 2 desc


--To check whether the values obtained above are correct or not

Select continent,SUM(cast(new_deaths as int)) as total_death_counts
From PortfolioProject..CovidDeaths
Where continent='Asia'
group by continent



Select Location,sum(cast(new_deaths as float)) as total_death_counts,
SUM(sum(cast(new_deaths as float)))  OVER (Order by Location) as Roll_death_count
From PortfolioProject..CovidDeaths
Where continent = 'Asia'
group by Location
order by 3 




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

--New Tests Vs New Cases, Total_tests Total_cases, Tests Vs Positivity rate

Select d.Location,d.continent,d.date,
v.new_tests,d.new_cases,
d.new_cases/(cast(v.new_tests as int))*100 as Daily_PositivePercentage,
v.total_tests,d.total_cases,
d.total_cases/(cast(v.total_tests as int))*100 as Total_PositivePercentage
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null and v.new_tests is not null and v.total_tests is not null
and d.new_cases is not null and d.total_cases is not null
order by 1,3

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

--Distribution of Vaccination Doses

Select continent,location,date,
abs((convert(bigint,people_vaccinated)) - LAG(convert(bigint,people_vaccinated))
    OVER (ORDER BY date )) as each_day_with_1st_dose,
(convert(bigint,people_vaccinated)) as total_people_vaccinated_with_1st_dose,
abs((convert(bigint,people_fully_vaccinated)) - LAG(convert(bigint,people_fully_vaccinated))
    OVER (ORDER BY date )) as each_day_with_2nd_dose,people_fully_vaccinated,
abs((convert(bigint,total_boosters)) - LAG(convert(bigint,total_boosters))
    OVER (ORDER BY date )) as each_day_boosters_dose,total_boosters
From  PortfolioProject..CovidVaccinations 
Where Location='United States' and people_vaccinated is not null and continent is not null   
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

Create View PopulationVaccinated as 
Select d.continent,d.location,d.date,d.population,v.new_vaccinations
From PortfolioProject..CovidDeaths d
join PortfolioProject..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
--order by 2,3

Drop View PopulationVaccinated


Select *
From PopulationVaccinated
Where continent is not null
Order by 1,2






Select 
  table_schema,
  table_name
from information_schema.views

select 
  schema_name(schema_id) as [Schema],
  name
from sys.views


