library(tidyverse)
library(arrow)
library(patchwork)

vax_compare <- read_parquet( './Data/Webslim/childhood_immunizations/state_compare.parquet') 
  


p1 <- ggplot(vax_compare,aes(x=value_nis, y=value_vaxview, text=geography)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed")+
  theme_classic() +
  ylim(75, 100)+
  xlim(75,100) +
  geom_errorbar(aes(xmin=value_nis_lcl, xmax=value_nis_ucl), color='gray', alpha=0.5)+

  ggtitle('Comparison of uptake from NIS and SchoolVaxView')

plotly::ggplotly(p1)

p1 + facet_wrap(~vaxview_survey_type)

p2 <- ggplot(vax_compare,aes(x=value_nis, y=value_epic, text=geography)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed")+
  theme_classic() +
  ylim(75, 100)+
  xlim(75,100)+
  geom_errorbar(aes(xmin=value_nis_lcl, xmax=value_nis_ucl), color='gray', alpha=0.5)+
  ggtitle('Comparison of uptake from NIS and Epic')

p2 + facet_wrap(~vaxview_survey_type)


p3 <- ggplot(vax_compare,aes(x=value_vaxview, y=value_epic)) +
  geom_point() +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed")+
  theme_classic() +
  ylim(75, 100)+
  xlim(75,100)+
  ggtitle('Comparison of uptake from Epic and SchoolVaxView')

p3 + facet_wrap(~vaxview_survey_type)

p1+p2+p3


# Add a small numeric offset for plotting
vax_compare$geo_epic <- as.numeric(factor(vax_compare$geography)) - 0.2
vax_compare$geo_vaxview <- as.numeric(factor(vax_compare$geography))
vax_compare$geo_nis <- as.numeric(factor(vax_compare$geography)) + 0.2

p4 <- ggplot() +
  geom_point(data=vax_compare, aes(x=geo_epic, y=value_epic), color='black') +
  geom_point(data=vax_compare, aes(x=geo_vaxview, y=value_vaxview), color='red') +
  geom_point(data=vax_compare, aes(x=geo_nis, y=value_nis), color='blue') +
  geom_linerange(data=vax_compare, aes(x=geo_nis, ymin=value_nis_lcl, ymax=value_nis_ucl), 
                 color='blue', alpha=0.1) +
  scale_x_continuous(
    breaks=as.numeric(factor(vax_compare$geography)),
    labels=levels(factor(vax_compare$geography))
  ) +
  theme_classic() +
  ylim(70, 100) +
  ggtitle('Comparison of uptake from Epic, NIS, SchoolVaxView') +
  theme(axis.text.x = element_text(angle=45, hjust=1))
p4

vax_compare_m <- vax_compare %>%
  dplyr::select(geography, starts_with('value')) %>%
    reshape2::melt(., id.vars=c('geography')) %>%
  filter(variable %in% c('value_nis','value_vaxview','value_epic')) %>%
  mutate(variable = gsub('value_', '', variable))

epic_ss <- vax_compare %>%
  dplyr::select(geography,N_patients_epic) %>%
  mutate(wgt = N_patients_epic/max(N_patients_epic, na.rm=T),
         variable= 'epic') %>%
  dplyr::select(geography, wgt, variable) 

nis_wgt <- vax_compare %>%
  mutate( nis_variance = ((value_nis_ucl - value_nis )/2)^2,
          wgt = 1/nis_variance,
          wgt = wgt/max(wgt, na.rm=T),
          variable='nis'
   ) %>%
  dplyr::select(geography,wgt, variable)

all_wgts <- bind_rows(epic_ss, nis_wgt)

vax_compare_m %>%
  mutate(variable = as.factor(variable)) %>%
  left_join(all_wgts, by=c('geography','variable')) %>%
  mutate(
    wgt = if_else(variable == 'vaxview', 0.5, wgt),
    jitter_x = as.numeric(as.factor(variable)) + runif(n(), -0.2, 0.2)  # jitter x values manually
  ) %>%
  ggplot() +
  geom_line(aes(x = jitter_x, y = value, group = geography), color = 'gray') +
  geom_point(aes(x = jitter_x, y = value, size = wgt), alpha=0.5) +
  scale_x_continuous(breaks = 1:length(unique(vax_compare_m$variable)),
                     labels = levels(as.factor(vax_compare_m$variable))) +
  theme_classic()
#Trends in vaxview data

vaxview <- read_parquet('./Data/Webslim/childhood_immunizations/state_kg_school_vax_view.parquet') %>%
  filter(vax=='mmr' )

vaxview %>%
  rename(schoolyear=year) %>%
  mutate(year=as.numeric(substr(schoolyear,1,4)),
         value=as.numeric(value)) %>%
  filter(geography %in% c('United States', 'Texas', 'Arizona', 'Idaho', "Massachusetts")) %>%
ggplot(aes(x=year, y=value, group=geography, color=geography)) +
  geom_line() +
  theme_classic() +
  ylab('uptake')


vax_compare %>%
  reshape2::melt(., id.vars=c ('geography')) %>%
  ggplot(aes(x=geography, y=value, group=variable, color=variable)) +
  geom_point() +
  theme_minimal()+ 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

#######################################
#Chronic disease compare
#######################################

epic_compare <- read_parquet('./Data/Webslim/chronic_diseases/brfss_cosmos_prevalence_compared.parquet')


epic_compare %>%
  filter(outcome_name=='Obesity') %>%
  ggplot(aes(x=value_epic, y=value, group=age, color=age, size=epic_pct_captured, alpha=0.5))+
  geom_point() +
  theme_classic() +
  ylim(15,70) +
  xlim(15,70) +
  ylab('% BRFSS')+
  xlab('% Epic Cosmos')+
  geom_abline(intercept=0, slope=1) +
  ggtitle('Obesity: Epic Cosmos vs BRFSS')

epic_compare %>%
  filter(outcome_name=='Diabetes') %>%
  ggplot(aes(x=value_epic, y=value, group=age, color=age, size=epic_pct_captured, alpha=0.5))+
  geom_point() +
  theme_classic() +
  ylim(0,40) +
  xlim(0,40) +
  ylab('% BRFSS')+
  xlab('% Epic Cosmos')+
  geom_abline(intercept=0, slope=1) +
  ggtitle('Diabetes: Epic Cosmos vs BRFSS')
