--Create the first query for total population MS SQL:
SELECT county, SUM(census_2020_count) AS total_population
FROM 2023_txpopest_county
GROUP BY county;

--Create the second query (c2) for average income:
SELECT county, AVG(MedianHH) AS avg_income
FROM 2023_txpopest_county
GROUP BY county;

--Create the main query to join the results of the two saved queries:
SELECT Query1_TotalPopulation.county, Query1_TotalPopulation.total_population, Query2_AvgIncome.avg_income
FROM Query1_TotalPopulation INNER JOIN Query2_AvgIncome ON Query1_TotalPopulation.county = Query2_AvgIncome.county
WHERE Query1_TotalPopulation.total_population > 100000
ORDER BY Query1_TotalPopulation.total_population DESC;


