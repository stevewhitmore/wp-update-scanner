#!/bin/bash

error_output=$1
date_time="$(date '+%A, %B %d %Y at %H:%M:%S')"
report_email=$(awk -F= '/email/ { print $2 }' config.txt)
record_file=$(awk -F= '/recordFile/ { print $2 }' config.txt)
log_file=$(awk -F= '/logFile/ { print $2 }' config.txt)

if [ -n "$error_output" ]; then
    echo -e '\n' "$date_time" '\n' "$error_output" >> "$log_file"

    echo "There was an error while running wp-update-scanner. Please see \"$log_file\" for details" \
    | mail -s "Script Failed: wp-update-scanner" "$report_email"

elif [ -n "$record_file" ]; then
    mail -s "WordPress Updates Needed" "$report_email" < "$record_file"
fi

pkill chromium && pkill chromedriver
exit
