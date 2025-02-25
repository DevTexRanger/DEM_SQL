# DEM_SQL
Examples of data wrangling using publicly-available demographic datasets and SQL

## Introduction 

This example will go through how to wrangle demographic data using MS SQL (Access). We will also be using R to download data (median household income) from the 5YR American Community Survey (ACS) to help us join the two subqeries, filter, and order the results. 

This exercise assumes that one maintans a databse which has collected, over the years, varioous population estimates from the same source as tables and stores them in a flat-file relational database. Even as a stand-alone exercise, this brief guide will demonstrate the value of using SQL in conjunction with other data processing tools, in this case R, to tackle complex queries. 

## Data 

You will need the following files, included in this repository, to complete this exercise:

Code:
- https://github.com/DevTexRanger/DEM_SQL/blob/main/Code/Multiyear_ACS_5year_Median_HHincome_ALL.r
- https://github.com/DevTexRanger/DEM_SQL/blob/main/Code/TotalPopulation_AvgIncome_TXCounties.sql
  
Data:
- https://github.com/DevTexRanger/DEM_SQL/blob/main/Data/2023_txpopest_county.csv
- https://github.com/DevTexRanger/DEM_SQL/blob/main/Data/medhhacs.csv

## Methodology 

For this exercise, you will need to download the latest population estimates for the State of Texas and counties from the Texas Demographic Center's (TDC) website: https://www.demographics.texas.gov/Estimates/2023/

Once here, select and download the file named "Total Population by County". 

Extract the contents of the file. The only file you will need is named "2023_txpopest_county.csv". Save it to a working directory. 

Open the file and explore its contents:

- FIPS: Federal Information Processing Standards code, a unique identifier assigned to geographical areas such as counties.
- county: The name of the county.
- census_2020_count: The population count from the 2020 Census.
- july1_2023_pop_est: The estimated population as of July 1, 2023.
- jan1_2024_pop_est: The estimated population as of January 1, 2024.
- num_chg_20_23: The numeric change in population between the 2020 Census and July 1, 2023.
- num_chg_20_24: The numeric change in population between the 2020 Census and January 1, 2024.
- pct_chg_20_23: The percentage change in population between the 2020 Census and July 1, 2023.
- pct_chg_20_24: The percentage change in population between the 2020 Census and January 1, 2024.

An image of the file headers appears below:


![image](https://github.com/user-attachments/assets/6637c53f-f425-4ccf-987d-1caee649526b)


Next, you will want to import this data into Access.

Here’s a step-by-step guide to help you import the file to Access: 

**Importing Data into Access**

1. **Open Access**:
   Open your Microsoft Access database where you want to import the data.

2. **Go to the External Data Tab**:
   Click on the "External Data" tab on the Ribbon.

3. **Choose the File Type**:
   Depending on the type of file you are importing (Excel, CSV, Text, etc.), click on the corresponding option in the "Import & Link" group. For example:
   - For Excel: Click on “New Data Source” > “From File” > “Excel.”
   - For CSV/Text files: Click on “Text File.”

4. **Select the File**:
   A dialog box will open. Click “Browse” to find and select the file you want to import.

5. **Import Options**:
   Once you’ve selected your file, you’ll see various import options. You can either:
   - Import the source data into a new table.
   - Append a copy of the records to an existing table.
   - Link the data source by creating a linked table.

6. **Follow the Wizard**:
   An Import Wizard will guide you through the rest of the process. Follow the on-screen instructions, which may include:
   - Specifying the range of data to import (if using Excel).
   - Choosing the delimiter (if using a CSV file).
   - Selecting the destination table in your Access database.
   - Mapping fields from the source to the destination table.

7. **Finish and Save**:
   Once you’ve completed the wizard, click “Finish.” You’ll have the option to save the import steps if you need to perform the same import again in the future.

With the file now in your database, you notice the absence of meedian household income data. We will be adding 2023 data to the table, but first we need to source this information. 
The 5-year American Community Survey (ACS) for 2023 covers data collected from 2018 to 2022 for their 2023 5-year release. This period provides a comprehensive overview of various social, economic, housing, and demographic characteristics.
To access this data, we will first need to requesdt a Census Data API Key from https://api.census.gov/data/key_signup.html. Don't forget to activate your key once you receive it!

Now, we will be requesting this data using the Multiyear_ACS_5year_Median_HHincome_ALL.r code available in this repository. 

Run the code and come back once the output file has been created and saved to your system. 

Using the same steps to add the 2023_txpopest_county.csv table to Access, repeat the same for importing medhhacs.csv. 

Once a new table has been created, you want to add a column (estimate) from medhhacs to 2023_txpopest_county. You do this by using a common value (county):

In Access, go to Create/Query Design; make sure you are in SQL View and enter the following code:

```
ALTER TABLE [2023_txpopest_county] ADD COLUMN estimate NUMBER; 
```
Check that the new column, estimate, has been added. 

With the data added, you want to Filters the results to:

- Include only counties with a total population greater than 100,000, and
- Orders the results by the total population in descending order.


```
SELECT july1_2023_pop_est, county
FROM [2023_txpopest_county]
WHERE july1_2023_pop_est > 100000
ORDER BY july1_2023_pop_est DESC;
```

Save the query. 

You can also calcualate the averge median household income across all counties:

```
SELECT AVG(estimate) AS avg_median_income
FROM [2023_txpopest_county];
```
You can run the following query to find out the top and bottom 10 Counties by Median Household Income:

```
SELECT TOP 10 county, estimate
FROM [2023_txpopest_county]
ORDER BY estimate DESC;
```
Due to that way in which Access handles queries, you will have to run two queries seperately.

```
SELECT TOP 10 county, estimate
FROM [2023_txpopest_county]
ORDER BY estimate ASC;
```

## Conclusion

In conclusion, this guide demonstrates the seamless integration of MS SQL (Access) and R to effectively wrangle and analyze demographic data. By combining the strengths of both tools, users can efficiently download, join, filter, and order data from the 5YR American Community Survey (ACS), providing valuable insights into median household incomes across counties. Whether maintaining a long-term database or working with a stand-alone dataset, this exercise showcases the practical benefits of leveraging SQL alongside R for addressing complex queries and enhancing data analysis capabilities.

I look forward to adding more examples in the near-future including ways to calculate population density, state median household income calculations, and much more!
