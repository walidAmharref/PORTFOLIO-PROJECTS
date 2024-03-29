select location,population,max(total_cases) as highestinfectedcontries ,max((total_cases/population))*100 as percentegepopulationinfected
from CovidDeaths
where population > 10000000
group by location,population
order by percentegepopulationinfected desc

select location,max(cast(total_deaths as int)) as TotalDeathsCount
from CovidDeaths
where continent is not null
group by location
order by TotalDeathsCount desc

--break things down by continent
select continent, max(cast(total_deaths as int)) as TotalDeathsCount
from CovidDeaths
where continent is not  null
group by continent
order by TotalDeathsCount desc

--showing contenents wth highest death count per population
--select continent,population,max(cast(total_deaths as int)) as highestdeathicontenets ,max((cast(total_deaths as int)/population))*100 as percentedeathperpoplation
--from CovidDeaths
--where continent is not null
--group by continent,population
--order by percentedeathperpoplation desc

select continent, max(cast(total_deaths as int)) as TotalDeathsCount
from CovidDeaths
where continent is not  null
group by continent
order by TotalDeathsCount desc

--Global numbers

select sum(cast(new_deaths as int)) as totaldeaths,  sum(new_cases) as totalcases ,sum(cast(new_deaths as int))/sum(new_cases) *100 as deathpercentage
from CovidDeaths
where continent is not null
--group by date
order by 1,2 

--looking at total population  vaccination 
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplvac
--,(rollingpeoplvac/dea.population)*100  
from CovidDeaths dea
join Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3


--use cte 
with popvsvac (continent,location, date, population, new_vaccinations, rollingpeoplvac)
as 
(
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplvac
--,(rollingpeoplvac/dea.population)*100  
from CovidDeaths dea
join Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
--order by 1,2,3
select * ,(rollingpeoplvac/population)*100  
from popvsvac

--temp table
drop table if exists  #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplvac numeric
)

insert into #percentpopulationvaccinated
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplvac
--,(rollingpeoplvac/dea.population)*100  
from CovidDeaths dea
join Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
select * , (rollingpeoplvac / population)*100  
from  #percentpopulationvaccinated 

         -- CREATE VIEW TO STORE DATA FOR LATER VESUALIZATIONS

create view percentpopulationvaccinated as
select dea.location, dea.continent, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplvac
--,(rollingpeoplvac/dea.population)*100  
from CovidDeaths dea
join Covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
 
select*
from percentpopulationvaccinated
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               