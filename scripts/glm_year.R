# glm_year.R
# Attempt to predict the year of the storm based on data about it.
# requires: source_data/1974_2024-08_stormevents.rds

# Libraries
require(tidyverse)

# Data
stormevents <- readRDS("./source_data/1974_2024-08_stormevents.rds") %>% 
  select(EVENT_ID, YEAR, INJURIES_DIRECT, INJURIES_INDIRECT, DEATHS_DIRECT,
         DEATHS_INDIRECT, DAMAGE_PROPERTY, DAMAGE_CROPS, BEGIN_LAT, BEGIN_LON,
         END_LAT, END_LON) %>% 
  mutate(
    EVENT_ID = as.numeric(EVENT_ID),
    YEAR = as.numeric(YEAR),
    INJURIES_DIRECT = as.numeric(INJURIES_DIRECT),
    INJURIES_INDIRECT = as.numeric(INJURIES_INDIRECT),
    DEATHS_DIRECT = as.numeric(DEATHS_DIRECT),
    DEATHS_INDIRECT = as.numeric(DEATHS_INDIRECT),
    DAMAGE_PROPERTY = case_when(
      str_detect(DAMAGE_PROPERTY, "h|H") ~ str_remove(DAMAGE_PROPERTY, "H") %>% 
        as.numeric() * 100,
      str_detect(DAMAGE_PROPERTY, "K") ~ str_remove(DAMAGE_PROPERTY, "K") %>% 
        as.numeric() * 1000,
      str_detect(DAMAGE_PROPERTY, "M") ~ str_remove(DAMAGE_PROPERTY, "M") %>% 
        as.numeric() * 1000000,
      str_detect(DAMAGE_PROPERTY, "B") ~ str_remove(DAMAGE_PROPERTY, "B") %>% 
        as.numeric() * 1000000000,
      .default = as.numeric(DAMAGE_PROPERTY)
    ),
    DAMAGE_CROPS = case_when(
      str_detect(DAMAGE_CROPS, "h|H") ~ str_remove(DAMAGE_CROPS, "H") %>% 
        as.numeric() * 100,
      str_detect(DAMAGE_CROPS, "K") ~ str_remove(DAMAGE_CROPS, "K") %>% 
        as.numeric() * 1000,
      str_detect(DAMAGE_CROPS, "M") ~ str_remove(DAMAGE_CROPS, "M") %>% 
        as.numeric() * 1000000,
      str_detect(DAMAGE_CROPS, "B") ~ str_remove(DAMAGE_CROPS, "B") %>% 
        as.numeric() * 1000000000,
      .default = as.numeric(DAMAGE_CROPS)
    ),
    BEGIN_LAT = as.numeric(BEGIN_LAT),
    BEGIN_LON = as.numeric(BEGIN_LON),
    END_LAT = as.numeric(END_LAT),
    END_LON = as.numeric(END_LON)
  )

# Model
model <- glm(
  YEAR ~ INJURIES_DIRECT + INJURIES_INDIRECT + DEATHS_DIRECT + DEATHS_INDIRECT + 
    DAMAGE_PROPERTY + DAMAGE_CROPS + BEGIN_LAT + BEGIN_LON + END_LAT + END_LON,
  data = stormevents
)
