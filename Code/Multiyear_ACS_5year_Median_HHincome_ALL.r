# Obtain median household income for all TX counties using the 5YR ACS (2020-2023) using RStudio
# This code is an amended version of Multiyear_ACS_5year_Median_HHincome  

# Load pacman; if not already installed, I highly encourage you to do so-especially if you're working with a lot of packages!
library("pacman")

# Load libraries using p_load
p_load(tidyverse, tidycensus)

# Census Data API Key (enter your Census Data API Key between the parentheses)
census_api_key("")

# Load variables for the latest "acs5"
v23 <- load_variables(2023, "acs5", cache = TRUE)

# Obtain table name for median household income using the View(v23) command by using the 
View(v23)

# Create a variable name (medianhh) using the assignment operator in R, using a named vector with one element (tablename)
medianhh <- c(tablename = "B19013A_001")

# Request data for 2020-2023 on the median household income for all TX counties
years <- lst(2020, 2021, 2022, 2023)
df <- map_dfr(
  years,
  ~ get_acs(
    geography = "county",
    variables = medianhh,
    state = "TX",
    year = .x,
    survey = "acs5",
    geometry = FALSE,
    output = "wide"
  ),
  .id = "year"
)

# Save the output 'df' as a CSV file; if on Windows, remember to use double backslashes (\\) as a directory separator in file paths 
write.csv(df, "...\\GitHub\\DEM_SQL\\medhhacs.csv")
