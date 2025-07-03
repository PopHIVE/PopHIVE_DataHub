## Using these data

The data shown on PopHIVE.org are found in ./Data/Webslim/. These files are mostly stored in parquet format. If using R, these can be downloaded using the arrow package in R. For example:

library(arrow)

url1 \<- '<https://github.com/ysph-dsde/PopHIVE_DataHub/raw/refs/heads/main/Data/Webslim/respiratory_diseases/rsv/ed_visits_by_county.parquet>'

ds1 \<- read_parquet(url1)

In general, the data closest to the source data are found in the 'value' column. Some datasets also include a 3 week moving average (value_smooth), and a smoothed value, scaled to between 0-100 (value_smooth_scale). The data in 'value' are generally drawn directly from the source data. Exceptions include:

1) In some datasets where national level data were not provided by the source, a national average is calculated using a population-weighted average.

2) For Epic Cosmos, if the data are based on fewer than 10 counts, the cell is suppressed. For visualization purposes, this is filled in with a value halfway between 0 and the minimum value reported for that state. These values are indicated with suppressed_flag=1.

Time-stamped archives of the data are available in the Pulled Data folder.

## FAQ

*Can I re-use the data from PopHIVE?*

Yes! Much of the data are drawn from publicly available Federal datasets, obtained from CDC or data.gov. Other datasets, including the data extracted from Epic Cosmos or Google Health Trends, can be used with appropriate attribution. A suggested citation would be 'Data from Epic Cosmos were obtained from the PopHIVE platform [url for Github corresponding to the specific dataset]

## Legal Disclaimer

These data and PopHIVE statistical outputs are provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose, and noninfringement. In no event shall the authors, contributors, or copyright holders be liable for any claim, damages, or other liability, whether in an action of contract, tort, or otherwise, arising from, out of, or in connection with the data or the use or other dealings in the data.

The PopHIVE statistical outputs are research tools intended for use in the fields of public health and medicine. They are not intended for clinical decision making, are not intended to be used in the diagnosis or treatment of patients and may not be useful or appropriate for any clinical purpose. Users of the PopHIVE statistical outputs should be aware of their responsibilities to ensure the ethical and appropriate use of this technology, including adherence to any applicable legal and regulatory requirements.

The content and data provided with the statistical outputs do not replace the expertise of healthcare professionals. Healthcare professionals should use their professional judgment in evaluating the outputs of the PopHIVE statistical outputs.
