# Obtain median household income for all TX counties using the 5YR ACS (2018-2022) using RStudio
# This code is an amended version of Multiyear_ACS_5year_Median_HHincome  

# Load pacman; if not already installed, I highly encourage you to do so-especially if you're working with a lot of packages!
library("pacman")

# Load libraries using p_load
p_load(dplyr, ggplot2, scales, tidyverse, tidycensus)

# Census Data API Key (enter your Census Data API Key between the parentheses)
census_api_key("")

# Load variables for the latest "acs5"
v23 <- load_variables(2023, "acs5", cache = TRUE)

# Obtain table name for median household income using the View(v23) command by using the 
View(v23)

# Create a variable name (medianhh) using the assignment operator in R, using a named vector with one element (tablename)
medHHIncTX <- c(medhhinc = "B19013A_001")

# Request data for 2023 on the median household income for all TX counties
texas_income <- get_acs(
  state = "Texas",
  geography = "county",
  variables = c(hhincome = "B19013_001"),
  year = 2023
) %>%
  mutate(NAME = str_remove(NAME, " County, Texas"))

# We now need to visualize the margins of error to understand the uncertainty around these estimates. Because TX is such a huge state, filter the data to include only the top 10 and bottom 10 counties based on the median household income before plotting it.
top_bottom_20 <- texas_income %>%
  arrange(desc(estimate)) %>%
  slice(c(1:10, (n() - 9):n()))


# Plot the data
ggplot(top_bottom_20, aes(x = estimate, y = reorder(NAME, estimate))) + 
  geom_point(size = 3, color = "darkgreen") + 
  labs(title = "Median household income", 
       subtitle = "Counties in Texas", 
       x = "", 
       y = "ACS estimate") + 
  theme_minimal(base_size = 12.5) + 
  scale_x_continuous(labels = label_dollar())

# Arrange in descending order by margin of error
# For counties with smaller population sizes, estimates are likely to have a larger margin of error compared to those with larger baseline populations.
texas_income %>% 
  arrange(desc(moe))

# The margins of error for estimated median household incomes range from $1,464 in Denton County to $46,346 in Glasscock County.
# In many instances, these margins of error are larger than the income differences between counties with adjacent rankings, indicating uncertainty in the rankings.
# Here, we use horizontal error bars to help us understand how our ranking of Texas counties by median household income and the uncertainty associated with these estimates. 

ggplot(top_bottom_20, aes(x = estimate, y = reorder(NAME, estimate))) + 
  geom_errorbarh(aes(xmin = estimate - moe, xmax = estimate + moe)) + 
  geom_point(size = 3, color = "darkgreen") + 
  theme_minimal(base_size = 12.5) + 
  labs(title = "Median household income", 
       subtitle = "Counties in Texas", 
       x = "2018-2022 ACS estimate", 
       y = "") + 
  scale_x_continuous(labels = label_dollar())

# rename NAME to county for use with MS Access
texas_income_output <- texas_income %>%
  rename(county = NAME)

# Save the output 'df' as a CSV file; if on Windows, remember to use double backslashes (\\) as a directory separator in file paths 
write.csv(texas_income_output, "...\\GitHub\\DEM_SQL\\medhhacs.csv")
