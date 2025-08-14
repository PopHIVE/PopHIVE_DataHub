library(epidatr)
library(tidyverse)
states.avail <- tolower(c(state.abb, 'us'))

################
###Doctors Visits
################
select_endpoints <- c('smoothed_cli')

end.date <- lubridate::floor_date(Sys.Date(), 'week') - 1 #most recent saturday

timepoints <- seq.Date(from=as.Date('2020-01-04'), to=end.date, by='week')

#the smoothed data are available daily from the API, but we just take the most recent saturday value
state <- epidatr::pub_covidcast(
  source = "doctor-visits", signal = select_endpoints,
  time_values=timepoints,
  geo_type = c("state"),
  time_type = "day" # important! This field defaults to "day", which won't work with data reported by week
) 
nation <- epidatr::pub_covidcast(
  source = "doctor-visits", signal = select_endpoints,
  geo_type = c("nation"),
  time_values=timepoints,
  time_type = "day" # important! This field defaults to "day", which won't work with data reported by week
)

# county <- epidatr::pub_covidcast(
#   source = "doctor-visits", signal = select_endpoints,
#   geo_type = c("county"),
#   time_values=timepoints,
#   time_type = "day" # important! This field defaults to "day", which won't work with data reported by week
# ) 

delphi_doctor_claims <- bind_rows(state, nation) %>%
  mutate(geography = state.name[match(toupper(geo_value), state.abb)],
         geography = if_else(geo_value=='us','United States', geography)
  ) %>%
  rename(date = time_value) %>%
  dplyr::select(geography, date,signal, value) %>%
  filter(!is.na(geography)) %>%
  mutate(
    outcome_name = if_else(grepl('covid',signal)|grepl('cli',signal) ,'COVID',
                           if_else(grepl('flu',signal),'FLU',
                                   if_else(grepl('rsv',signal),'RSV',NA_character_

                                   ))),
    outcome_name = 'COVID',
    source ='Delphi Doctor Claims',
    age_strata = 'none'
  )%>%
  dplyr::select(-signal) %>%
  rename(Outcome_value1 = value)


  vroom::vroom_write( delphi_doctor_claims, "./Data/Pulled Data/Delphi/delphi_data_doctor.csv.gz", ",")

  ####################################################################
######Hospital Claims
####################################################################
select_endpoints <- c('smoothed_covid19_from_claims')

end.date <- lubridate::floor_date(Sys.Date(), 'week') - 1 #most recent saturday

timepoints <- seq.Date(from=as.Date('2020-01-04'), to=end.date, by='week')

#the smoothed data are available daily from the API, but we just take the most recent saturday value
state <- epidatr::pub_covidcast(
  source = "hospital-admissions", signal = select_endpoints,
  time_values=timepoints,
  geo_type = c("state"),
  time_type = "day" # important! This field defaults to "day", which won't work with data reported by week
) 
nation <- epidatr::pub_covidcast(
  source = "hospital-admissions", signal = select_endpoints,
  geo_type = c("nation"),
  time_values=timepoints,
  time_type = "day" # important! This field defaults to "day", which won't work with data reported by week
) 
# county <- epidatr::pub_covidcast(
#   source = "hospital-admissions", signal = select_endpoints,
#   geo_type = c("county"),
#   time_values=timepoints,
#   time_type = "day" # important! This field defaults to "day", which won't work with data reported by week
# ) 

delphi_hosp_claims <-  bind_rows(state, nation) %>%
  mutate(geography = state.name[match(toupper(geo_value), state.abb)],
  geography = if_else(geo_value=='us','United States', geography)
  ) %>%
  rename(date = time_value) %>%
  dplyr::select(geography, date,signal, value) %>%
  filter(!is.na(geography)) %>%
  mutate(
    outcome_name = if_else(grepl('covid',signal),'COVID',
                                 if_else(grepl('flu',signal),'FLU',
                                               if_else(grepl('rsv',signal),'RSV',NA_character_
                                                             
                                         ))),
    source ='Delphi Hospital Claims',
    age_strata = 'none'
    )%>%
  dplyr::select(-signal)%>%
  rename(Outcome_value1 = value)


  vroom::vroom_write(delphi_hosp_claims,  "./Data/Pulled Data/Delphi/hospital_claims_data.csv.gz", ",")


###########################################################
###DELPHI NHSN
###########################################################

nhsn_endpoints <- c('confirmed_admissions_covid_ew', 'confirmed_admissions_rsv_ew','confirmed_admissions_flu_ew')

state <- epidatr::pub_covidcast(
  source = "nhsn", signal = nhsn_endpoints,
  geo_type = c("state"),
  time_type = "week" # important! This field defaults to "day", which won't work with data reported by week
) 
nation <- epidatr::pub_covidcast(
  source = "nhsn", signal = nhsn_endpoints,
  geo_type = c("nation"),
  time_type = "week" # important! This field defaults to "day", which won't work with data reported by week
) 

#Data for RSV from the pre-October 31, 2024 voluntary reporting period is particularly low quality
delphi_nhsn <-  bind_rows(state, nation)%>%
  mutate(geography = state.name[match(toupper(geo_value), state.abb)],
         geography = if_else(geo_value=='us','United States', geography),
         remove = if_else(
           (grepl('rsv', signal)|grepl('flu', signal)) & 
           time_value<'2024-10-31',
           1,
           0)
  ) %>%
  filter(remove==0) %>%
  rename(date = time_value) %>%
  dplyr::select(geography, date,signal, value) %>%
  filter(!is.na(geography)) %>%
  mutate(
    outcome_name = if_else(grepl('covid',signal),'COVID',
                           if_else(grepl('flu',signal),'FLU',
                                   if_else(grepl('rsv',signal),'RSV',NA_character_
                                           
                                   ))),
    source ='CDC NHSN',
    age_strata = 'none'
  ) %>%
  dplyr::select(-signal)%>%
  rename(Outcome_value1 = value)
 
 vroom::vroom_write(delphi_nhsn,  "./Data/Pulled Data/Delphi/nhsn.csv.gz", ",")
 