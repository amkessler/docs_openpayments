library(tidyverse)
library(janitor)
library(lubridate)
library(writexl)

#target drug query done in BigQuery. Results exported to csv and we'll load them here:
targetdrugsonly <- read_csv("processed_data/targetdrugsonly.csv", col_types = cols(.default = "c"))

glimpse(targetdrugsonly)

#clean up column names
targetdrugsonly <- targetdrugsonly %>% 
  clean_names()

#format columns
targetdrugsonly <- targetdrugsonly %>% 
  mutate(
    total_amount_of_payment_us_dollars = as.numeric(total_amount_of_payment_us_dollars),
    date_of_payment = ymd(date_of_payment),
    number_of_payments_included_in_total_amount = as.numeric(number_of_payments_included_in_total_amount),
    payment_publication_date = ymd(payment_publication_date)
  ) 

glimpse(targetdrugsonly)

#if there are any case issues with the doctor names or drug names, let's standardize that
targetdrugsonly <- targetdrugsonly %>% 
  mutate(
    physician_first_name = str_trim(str_to_upper(physician_first_name)),
    physician_middle_name = str_trim(str_to_upper(physician_middle_name)),
    physician_last_name = str_trim(str_to_upper(physician_last_name)),
    recipient_city = str_trim(str_to_upper(recipient_city)),
    name_of_drug_or_biological_or_device_or_medical_supply_1 = str_trim(str_to_upper(name_of_drug_or_biological_or_device_or_medical_supply_1)),
    name_of_drug_or_biological_or_device_or_medical_supply_2 = str_trim(str_to_upper(name_of_drug_or_biological_or_device_or_medical_supply_2)),
    name_of_drug_or_biological_or_device_or_medical_supply_3 = str_trim(str_to_upper(name_of_drug_or_biological_or_device_or_medical_supply_3)),
    name_of_drug_or_biological_or_device_or_medical_supply_4 = str_trim(str_to_upper(name_of_drug_or_biological_or_device_or_medical_supply_4)),
    name_of_drug_or_biological_or_device_or_medical_supply_5 = str_trim(str_to_upper(name_of_drug_or_biological_or_device_or_medical_supply_5))
  )


#total money?
targetdrugsonly %>% 
  summarise(totalpayments = sum(total_amount_of_payment_us_dollars))

targetdrugsonly %>% 
  group_by(program_year) %>% 
  summarise(totalpayments = sum(total_amount_of_payment_us_dollars))

targetdrugsonly %>% 
  group_by(covered_recipient_type) %>% 
  summarise(totalpayments = sum(total_amount_of_payment_us_dollars))

#top docs
targetdrugsonly %>% 
  group_by(physician_last_name, physician_first_name, recipient_state) %>% 
  summarise(totalpayments = sum(total_amount_of_payment_us_dollars)) %>%
  arrange(desc(totalpayments))

