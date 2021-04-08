library(tidyverse)
library(janitor)
library(lubridate)
library(fst)

#load raw files from CMS
#download at: https://www.cms.gov/OpenPayments/Explore-the-Data/Dataset-Downloads
gen2016_raw <- read_csv("raw_data/OP_DTL_GNRL_PGYR2016_P01222021.csv", col_types = cols(.default = "c"))
gen2017_raw <- read_csv("raw_data/OP_DTL_GNRL_PGYR2017_P01222021.csv", col_types = cols(.default = "c"))
gen2018_raw <- read_csv("raw_data/OP_DTL_GNRL_PGYR2018_P01222021.csv", col_types = cols(.default = "c"))
gen2019_raw <- read_csv("raw_data/OP_DTL_GNRL_PGYR2019_P01222021.csv", col_types = cols(.default = "c"))

#convert each raw dataset to fst format 
write_fst(gen2016_raw, "raw_data/gen2016_raw.fst")
write_fst(gen2017_raw, "raw_data/gen2017_raw.fst")
write_fst(gen2018_raw, "raw_data/gen2018_raw.fst")
write_fst(gen2019_raw, "raw_data/gen2019_raw.fst")

#glimpse to inspect column structure
glimpse(gen2016_raw)

gen2019_raw <- read_fst("raw_data/gen2019_raw.fst")
gen2018_raw <- read_fst("raw_data/gen2018_raw.fst")
gen2017_raw <- read_fst("raw_data/gen2017_raw.fst")
gen2016_raw <- read_fst("raw_data/gen2016_raw.fst")

#cut down unneeded columns and records
gen2019_raw <- gen2019_raw %>% 
  select(
    -Teaching_Hospital_CCN,
    -Teaching_Hospital_ID,
    -Teaching_Hospital_Name
  ) %>% 
  filter(Covered_Recipient_Type != "Covered Recipient Teaching Hospital")

gen2018_raw <- gen2018_raw %>% 
  select(
    -Teaching_Hospital_CCN,
    -Teaching_Hospital_ID,
    -Teaching_Hospital_Name
  ) %>% 
  filter(Covered_Recipient_Type != "Covered Recipient Teaching Hospital")

gen2017_raw <- gen2017_raw %>% 
  select(
    -Teaching_Hospital_CCN,
    -Teaching_Hospital_ID,
    -Teaching_Hospital_Name
  ) %>% 
  filter(Covered_Recipient_Type != "Covered Recipient Teaching Hospital")

gen2016_raw <- gen2016_raw %>% 
  select(
    -Teaching_Hospital_CCN,
    -Teaching_Hospital_ID,
    -Teaching_Hospital_Name
  ) %>% 
  filter(Covered_Recipient_Type != "Covered Recipient Teaching Hospital")




#combine raw datasets
gen_combined_raw <- bind_rows(gen2016_raw, gen2017_raw, gen2018_raw, gen2019_raw)

#save combined raw file
write_fst(gen_combined_raw, "raw_data/gen_combined_fouryears_raw.fst")
