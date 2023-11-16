#!/bin/bash

# to import sea ice data
# you will need to unzip the files manually, once they downloaded

URL="https://noaadata.apps.nsidc.org/NOAA/G02135/south/monthly/shapefiles/shp_extent"
 
MONTHS="01_Jan 02_Feb 03_Mar 04_Apr 05_May 06_Jun 07_Jul 08_Aug 09_Sep 10_Oct 11_Nov 12_Dec"
 
YEARS={2000..2023}
 
for m in $MONTHS; do
    for y in {2000..2023}; do
        n=${m:0:2}
        wget "$URL/$m/extent_S_${y}${n}_polygon_v3.0.zip"
    done
done


