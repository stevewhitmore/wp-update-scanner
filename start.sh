#!/bin/bash

# Grab headings from config.txt and convert them into an array of strings
scattered_config_headings=$(awk -F'[][]' '{print $2}' config.txt)
tidy_config_headings=$(echo "$scattered_config_headings" | xargs)
config_headings_as_array=' ' read -r -a array <<< "$tidy_config_headings"

# Pop the "FollowUp" name off the end of the array
unset "array[${#array[@]}-1]"

# Run python script on each website name
for website in "${array[@]}"
do
    ./handle_py_script.sh "$website"
done

# Send out email with update information
./notify_updates.sh

# Clear out contents of record file
record_file=$(awk -F= '/recordFile/ { print $2 }' config.txt)
truncate -s 0 "$record_file"

exit
