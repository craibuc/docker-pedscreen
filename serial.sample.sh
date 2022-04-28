#!/usr/bin/env bash

# Purpose:
#   Generate the extracts for the prior month for the listed locations.
#
# Preparation:
#  - copy file to sample.sh ($ cp serial.sample.sh serial.sh)
#  - make file executable ($ chmod +x serial.sh)
#  - add specific site (e.g. AAAA,BBBB) and department # (e.g. 111111,222222) to the locations variable
#
# Usage:
#   ./serial.sh

site="ABCD"
declare -A locations=( [AAAA]="111111" [BBBB]="222222" [CCCC]="333333" )

# first day of the prior month
date_start="$(date -d "month ago" "+%Y-%m-01")"

# first day of the prior month
date_end="$(date -d "$(date +%Y-%m-01) - 1 day" "+%Y-%m-%d")"

for location in "${!locations[@]}"; do

    # process ETL
    echo "Processing $location[${locations[$location]}] for ${date_start} to ${date_end}..."

    docker run --rm --env-file=.env --volume $(pwd)/output:/app/output pedscreen:latest --site_id $site --department_id ${locations[$location]} --location_id ${location} --date_start ${date_start} --date_end ${date_end}

done