Select *
From Portfolio_Project.dbo.CovidDeaths
order by 3,4

Select *
From Portfolio_Project.dbo.CovidVaccinations
order by 3,4


Drop View daily_CasesPoulationDeaths 

Create View daily_CasesPoulationDeaths as 
Select continent,Location,date,total_cases,new_cases,total_deaths,population
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
--order by 2,3

Select *
From daily_CasesPoulationDeaths
Where continent is not null
order by 2,3

--Looking at total_cases Vs total_deaths  i.e. Death_Percentage
--Likelihood of dying if you contract with covid in your country

Drop View World_DeathPercentage 

Create View World_DeathPercentage as 
Select sum(new_cases) as Total_Cases,sum(cast(new_deaths as int)) as Total_Deaths,sum(cast(new_deaths as int))/sum(new_cases)*100 as Global_DeathPercentage
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
--order by 1,2


Select *
From World_DeathPercentage
order by 1,2

Create View CountryWise_DeathPercentage as 
Select Location,sum(new_cases) as Total_Cases,sum(cast(new_deaths as int)) as Total_Deaths,sum(cast(new_deaths as int))/sum(new_cases)*100  as Death_Percentage
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
Group by location
--order by 2 desc

Select *
From CountryWise_DeathPercentage
order by 2 desc


Drop View dailyIndia_DeathPercentage 

Create View dailyIndia_DeathPercentage as
Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
Where Location='India'
--order by 2

Select *
From dailyIndia_DeathPercentage
order by 2

--Looking at total_cases Vs Population
--Shows what percentage got covid 

Drop View World_TotalCasesVsPopulation 

Create View World_TotalCasesVsPopulation as
Select continent,Location,population,max(total_cases)as total_cases,(max(total_cases)/population)*100 as ppln_prcnt_got_Covid
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
Group by continent,Location,population
--order by 3 desc

Select *
From World_TotalCasesVsPopulation
order by 3 desc


Drop View India_TotalCasesVsPopulation

Create View India_TotalCasesVsPopulation as
Select Location,date,population,total_cases,(total_cases/population)*100 as ppln_prcnt_got_Covid
From Portfolio_Project..CovidDeaths
Where Location='India'
--order by 1,2

Select *
From India_TotalCasesVsPopulation
order by 1,2


--Hospital and ICU Admissions on daily basis 

Drop View USA_Hospital_ICU_Admn

Create View USA_Hospital_ICU_Admn as
Select Location,date,population,
(convert(int,hosp_patients)) as Currently_hospital_patients ,
(convert(int,hosp_patients)) - LAG(convert(int,hosp_patients))
    OVER (ORDER BY date ) as hospital_in_out,
(convert(int,icu_patients)) as Currently_patients_in_icu,
(convert(int,icu_patients)) - LAG(convert(int,icu_patients))
    OVER (ORDER BY date ) as icu_in_out,
(convert(int,new_deaths)) as new_deaths_each_day,
(convert(int,total_deaths)) as total_deaths
From Portfolio_Project..CovidDeaths
Where Location='United States' and hosp_patients is not null
--order by 2

Select *
From USA_Hospital_ICU_Admn
order by 2


Drop View USA_HospPatients_ICU_Deaths

Create View USA_HospPatients_ICU_Deaths as
Select continent,Location,date,population,
hosp_patients as Currently_hospital_patients ,
icu_patients as Currently_patients_in_icu,
(cast(icu_patients as float))/(cast(hosp_patients as float))*100 as icu_admnPercentage,
(convert(int,new_deaths)) as new_deaths_each_day,
(convert(int,total_deaths)) as total_deaths
From Portfolio_Project..CovidDeaths
Where  location='United States' and continent is not null and hosp_patients is not null and icu_patients is not null
--order by 2,3

Select *
From USA_HospPatients_ICU_Deaths
order by 2,3


--Looking at countries with highest infection rates compares to their population

Drop View InfectionRate_CasesVsPopulation

Create View InfectionRate_CasesVsPopulation as
Select Location,population,Max(total_cases) as highest_infection_count,Max((total_cases/population)*100) as percent_ppln_infected
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
group by Location,population 
--order by 4 desc

Select *
From InfectionRate_CasesVsPopulation
order by 4 desc

--Showing Countries with Highest Death Counts

Drop View total_death_counts

Create View total_death_counts as
Select Location,Max(cast(total_deaths as int)) as total_death_counts
From Portfolio_Project..CovidDeaths
where continent is not null and Location not in ('World','European Union','International')
group by Location
--order by 2 desc

Select *
From total_death_counts
order by 2 desc

--Break it down by Continents
Drop View ContinentWise_death_counts

Create View ContinentWise_death_counts as
Select continent, SUM(cast(new_deaths as int)) as total_death_counts
From Portfolio_Project..CovidDeaths
where continent is not null and Location not in ('World','European Union','International')
group by continent
--order by 2 desc

Select *
From ContinentWise_death_counts
order by 2 desc


--To check whether the values obtained above are correct or not
Drop View Asia_death_counts

Create View Asia_death_counts as
Select continent,SUM(cast(new_deaths as int)) as total_death_counts
From Portfolio_Project..CovidDeaths
Where continent='Asia'
group by continent

Select *
From Asia_death_counts


Drop View AsiaCumulative_death_counts

Create View AsiaCumulative_death_counts as
Select Location,sum(cast(new_deaths as float)) as total_death_counts,
SUM(sum(cast(new_deaths as float)))  OVER (Order by Location) as Roll_death_count
From Portfolio_Project..CovidDeaths
Where continent = 'Asia'
group by Location
--order by 3 

Select *
From AsiaCumulative_death_counts
order by 3 

--Global Data of new cases and new deaths on daily basis

Drop View DailyGlobal_DeathsVsCases

Create View DailyGlobal_DeathsVsCases as
Select date,SUM(new_cases) as DailyGlobal_TotalCases, SUM(cast(new_deaths as int)) as DailyGlobal_TotalDeaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Daily_DeathPercentage
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
group by date
--order by 1,2

Select *
From DailyGlobal_DeathsVsCases
order by 1,2

--Total_Value of covid cases and covid deaths till April 05 2022

Drop View Total_CasesAndDeaths_till_Apr5_2022

Create View Total_CasesAndDeaths_till_Apr5_2022 as
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
Where continent is not null and Location not in ('World','European Union','International')
--order by 1,2

Select *
From Total_CasesAndDeaths_till_Apr5_2022
order by 1,2

Select *
From Portfolio_Project..CovidVaccinations
order by 3,4

--Joining 2 tables

Select *
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date




--New Tests Vs New Cases, Total_tests Total_cases, Tests Vs Positivity rate
Drop View TestCasesPositvityRate

Create View TestCasesPositvityRate as
Select d.Location,d.continent,d.date,
v.new_tests,d.new_cases,
d.new_cases/(cast(v.new_tests as int))*100 as Daily_PositivePercentage,
v.total_tests,d.total_cases,
d.total_cases/(cast(v.total_tests as int))*100 as Total_PositivePercentage
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null and v.new_tests is not null and v.total_tests is not null
and d.new_cases is not null and d.total_cases is not null and d.Location not in ('World','European Union','International')
--order by 1,3

Select *
From TestCasesPositvityRate
order by 1,3

--Looking at total populations Vs daily_vaccinations

Select d.continent,d.Location,d.date,d.population,v.new_vaccinations
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null and d.Location not in ('World','European Union','International')
order by 2,3


--vaccination getting on the daily basis and Cumulative_Vaccinations
Drop View DailyCumulativeVaccinations

Create View DailyCumulativeVaccinations as
Select d.continent,d.Location,d.date,d.population, v.new_vaccinations,
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.Location Order by d.Location,d.date) as Rolling_people_vaccinated
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null and d.Location not in ('World','European Union','International')
--order by 2,3

Select *
From DailyCumulativeVaccinations
order by 2,3



--USA_Distribution of Vaccination Doses


Drop View USA_fst2ndBoosterVaccinations

Create View USA_fst2ndBoosterVaccinations as
Select continent,location,date,
abs((convert(bigint,people_vaccinated)) - LAG(convert(bigint,people_vaccinated))
    OVER (ORDER BY date )) as each_day_with_1st_dose,
(convert(bigint,people_vaccinated)) as total_people_vaccinated_with_1st_dose,
abs((convert(bigint,people_fully_vaccinated)) - LAG(convert(bigint,people_fully_vaccinated))
    OVER (ORDER BY date )) as each_day_with_2nd_dose,people_fully_vaccinated,
abs((convert(bigint,total_boosters)) - LAG(convert(bigint,total_boosters))
    OVER (ORDER BY date )) as each_day_boosters_dose,total_boosters
From  Portfolio_Project..CovidVaccinations 
Where Location='United States' and people_vaccinated is not null and continent is not null   
--order by 2,3

Select *
From USA_fst2ndBoosterVaccinations
order by 2,3


--Using CTE

With PopvsVac (continent,Location,date,population,new_vaccinations,Rolling_people_vaccinated)
as
(
Select d.continent,d.location,d.date,d.population, v.new_vaccinations,
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.Location Order by d.Location,d.date) as Rolling_people_vaccinated
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
--order by 2,3
)
Select *,(Rolling_people_vaccinated/population)*100 as Percent_Population_Vaccinated
From PopVsVac
Where new_vaccinations is not null
order by 2,3

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
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null
order by 2,3
Select *,(Rolling_people_vaccinated/population)*100 as Percent_Population_Vaccinated
From #PercentPopulationVaccinated

--Creating a View

Create View PopulationVaccinated as 
Select d.continent,d.location,d.date,d.population, v.new_vaccinations,
SUM(cast(v.new_vaccinations as bigint)) OVER (Partition by d.Location Order by d.Location,d.date) as Rolling_people_vaccinated,
(cast(v.new_vaccinations as bigint))/d.population*100 as DailyBasis_PopulationVaaccinated
From Portfolio_Project..CovidDeaths d
join Portfolio_Project..CovidVaccinations v
on d.location=v.location
and d.date=v.date
Where d.continent is not null and v.new_vaccinations is not null and d.Location not in ('World','European Union','International')
--order by 2,3

Drop View PopulationVaccinated


Select *
From PopulationVaccinated
Where continent is not null
Order by 2,3

--to see the Views created

Select 
  table_schema,
  table_name
from information_schema.views

select 
  schema_name(schema_id) as [Schema],
  name
from sys.views