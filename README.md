# Antarctica Biodiversity Competition

### EG-ABI Data visualisation competition: “Impacts of climate change around Antarctica and the Southern Ocean” 

Diatoms are a type of algae which account for up to 20% of global photosynthesis. They help to remove CO2 from the atmosphere and create oxygen, and they are important components of the marine food web. They are especially diverse, abundant and important in the polar oceans, where they often live in sea-ice. As the ocean warms and sea-ice cover is lost, habitats for these polar diatoms shift to the open water, where they are faced with the additional threat of ocean acidification. The consequences of this for marine photosynthesis and the cascading effects on food webs in the ocean is unknown, but potentially huge. 

Decreases in sea-ice may be having an influence on the number of species of diatoms in the Southern Ocean - in this data visualisation we show diatom species richness (the number of species present) from 2007 to 2021, using data collected through AusCPR. 

Sea ice extent data are from the National Sea and Ice Data Centre ([NSIDC](https://nsidc.org/data/seaice_index)). 

Data for diatom species richness are from the Australian Continuous Plankton Recorder ([AusCPR](https://www.gbif.org/dataset/29b28617-c91c-4bc9-b3aa-c97960a8b5c8)), we filtered this dataset below 55 degrees latitude. 

To reproduce these results, do the following:

- clone this reposititory
- run the bash script to pull the sea-ice extent shapefiles from NSIDC
- run the 2 R scripts in sequence (first JWA_data_prep.R, then EG-EDI-JWA.R), making sure to change any relevant file paths (see the comments), and setting the working directory with setwd as appropriate

The gif file is our final submission. 

Submitted by:

 - Johanna Winder
 - William Boulton
 - Antonia Otte

17/11/2023

University of East Anglia
