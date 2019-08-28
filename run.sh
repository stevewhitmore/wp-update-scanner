#!/bin/bash

date_time="$(date '+%A, %B %d %Y at %H:%M:%S')"
report_email=$(awk -F= '/email/ { print $2 }' config.txt)
record_file=$(awk -F= '/recordFile/ { print $2 }' config.txt)
log_file=$(awk -F= '/logFile/ { print $2 }' config.txt)

run_update_scanner_script() {
    python ./update_scanner.py
}
output=$(run_update_scanner_script 2>&1)

if [ -n "$output" ]; then
    echo -e "$date_time" '\n' "$output" >> "$log_file"

    echo "There was an error while running wp-update-scanner. Please see \"$log_file\" for details" \
    | mail -s "Script Failed: wp-update-scanner" "$report_email"

    exit
fi

if [ -n "$record_file" ]; then
    mail -s "WordPress Updates Needed" "$report_email" < "$record_file"
fi

# Make extra sure all processes are dead when script ends
pkill chromium && pkill chromedriver
exit
