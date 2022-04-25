# process all rows in the process.csv
while IFS=, read -r department_id location_id date_start date_end; do

  # skip header row
  if [ "$department_id" != "department_id" ] && [ ${department_id:0:1} != "#" ]; then

    echo "docker run --rm --env-file=.env --volume $(pwd)/output:/app/output pedscreen:latest --department_id $department_id --location_id $location_id --date_start $date_start --date_end $date_end"
    # docker run --rm --env-file=.env --volume $(pwd)/output:/app/output pedscreen:latest --department_id $department_id --location_id $location_id --date_start $date_start --date_end $date_end

  fi

done < process.csv