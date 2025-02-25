--Run these as seperate, independent queries
--Once a new table has been created, you want to add a column (estimate) from medhhacs to 2023_txpopest_county. You do this by using a common value (county):

ALTER TABLE [2023_txpopest_county] ADD COLUMN estimate NUMBER; 

-- Include only counties with a total population greater than 100,000, and Orders the results by the total population in descending order.
SELECT july1_2023_pop_est, county
FROM [2023_txpopest_county]
WHERE july1_2023_pop_est > 100000
ORDER BY july1_2023_pop_est DESC;

--You can also calculate the averge median household income across all counties:
SELECT AVG(estimate) AS avg_median_income
FROM [2023_txpopest_county];

--You can run the following query to find out the top and bottom 10 Counties by Median Household Income:

SELECT TOP 10 county, estimate
FROM [2023_txpopest_county]
ORDER BY estimate DESC;

SELECT TOP 10 county, estimate
FROM [2023_txpopest_county]
ORDER BY estimate ASC;
