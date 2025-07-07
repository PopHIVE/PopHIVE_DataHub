### National Syndromic Surveillance Program

The National Syndromic Surveillance Program (NSSP) provides data on emergency department visits for influenza, respiratory syncytial virus, and COVID-19 each week, organized by state and county, where available. The numbers are based on recorded diagnoses. NSSP data are made available by the CDC.

-   Percent of ED visits recorded as being due to RSV across all age groups, obtained from jurisdictions and emergency departments participating in the National Syndromic Surveillance Program. County-level data are shown where available; otherwise state-level data are presented.

-   These measures are based on diagnoses recorded in the electronic health records and not based directly on viral test results

-   For Missouri, CDC does not report values for NSSP, and the values can be filled with state-level data from Epic Cosmos.

### Epic Cosmos

Cosmos is a dataset created in collaboration with a community of Epic health systems representing more than 300 million patient records from over 1633 hospitals and 37,900 clinics from all 50 states, D.C., Canada, Lebanon, and Saudi Arabia. Summary statistics were obtained using the SlicerDicer tool in Epic Cosmos.

-   ED visits: Percent of ED visits recorded as being due to RSV, obtained from facilities using the Epic electronic health records platform and participating in Epic Cosmos. Epic Cosmos captures varying amounts of the population in different regions, so the data might be a more representative measure of viral activity in the community in some areas than others.

-   Where there are fewer than 10 cases per time period, the data are suppressed. These values are filled in with a value halfway between 0 and the minimum reported value on the time series. These values are noted with suppressed_flag=1

### RESP-NET

The CDC’s Respiratory Virus Hospitalization Surveillance Network (RESP-NET) monitors laboratory-confirmed hospitalizations associated with influenza, COVID-19, and respiratory syncytial virus (RSV) among children and adults. The data are collected from hospitals in selected counties and county equivalents. This dataset has several important advantages: the area around the hospitals is well described, so rates of disease adjusted for population size can be accurately reported. The selected counties include \~10% of the US population and are demographically representative of the country. Detailed patient demographic information is available, and officials actively search for cases to ensure they capture all cases in the data. A limitation is that the network relies on the clinicians to perform viral tests as part of their routine clinical practice, so they likely miss cases that are not tested

-   Number of laboratory-confirmed cases of the virus per 100,000 people. RESP-NET is an active surveillance system with a well-defined population, so it is possible to obtain estimates of incidence (cases/population). This indicator is only available for certain states. The data comes from certain counties within the state and does not capture the entire population.

### National Wastewater Surveillance program 

Testing for viruses in wastewater can provide an efficient way to identify the levels of virus circulation in the community. The CDC’s National Wastewater Surveillance program obtains samples from select communities around the US and presents the data aggregated by state. These data can provide an early indication of viral activity. Limitations include an inability to link detected back to particular groups of individuals and challenges in comparing viral levels across sites that use different methodologies. The sewage is not necessarily representative of the entire population. These data are made available by the CDC.

-   Wastewater virus activity level (WVAL) value is calculated by CDC as exp(\# of standard deviations above baseline). The WVAL therefore represents a measure of relative intensity. The [methods](https://www.cdc.gov/nwss/about-data.html#data-method) for calculating the baseline vary by virus.

### ** Google Trends API** 

Google Trends data represent scaled Google search volume by week and state or metropolitan area and are obtained from the Google Health Trends API for non-commercial purposes.

-   This represents the volume of Google searches for ‘RSV’, statistically adjusted to remove searches related to RSV immunizations. We obtained Google Search volume by week and state for ‘RSV’ and for the category ‘Respiratory syncytial virus vaccine’ (11j30ybfx6). We are interested in searches related to clinical activity, not due to searching for information on the vaccine. These two time series show distinct patterns. Searches for RSV vaccines surge in early-Fall. Searches for ‘rsv’ in general have a small hump in early fall that corresponds to the searches for vaccine information, and a second peak later in the fall and into the winter that corresponds to the seasonal epidemic.

-   To subtract out the signal of vaccination searches from the general RSV signal, we fit a mixed effects model where the outcome was search volume for RSV by state and week, the covariate was search volume for RSV vaccines by week and state in the summer months, and there was a random intercept for state. There was an interaction term for ‘season’, which allowed the effect of search volume to differ in July-October. Using the regression coefficients, we calculate the adjusted search volume as Adjusted volume = RSV_search_volume - season\*2.72\*vax_search_volume - (1-season)\*3.41\*search_volume_vax. The latest raw, unadjusted search volumes are available from [here](https://github.com/ysph-dsde/PopHIVE_DataHub/tree/main/Data/Pulled%20Data/Google%20RSV).

### National Respiratory and Enteric Virus Surveillance System (NREVSS).

Select laboratories around the United States participate in this system and report the number of positive tests for a virus and the number of tests performed. These data are made available by the CDC.
