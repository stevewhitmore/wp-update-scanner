#!/bin/bash

date_time="$(date '+%A, %B %d %Y at %H:%M:%S')"
report_email=$(awk -F= '/email/ { print $2 }' config.txt)
record_file=$(awk -F= '// { print $2 }' config.txt)
log_file=$(awk -F= '/logFile/ { print $2 }' config.txt)

run_backup_db_script() {
    python ./backup_db.py
}
output=$(run_backup_db_script 2>&1)
echo -e "$(date)" '\n' "$output" >> "$log_file"

#***************************
# This is gross and needs to be completed/cleaned up
if [ -z "$output" ]; then
    echo foo
else
    notify-send "some alerming topic" "$date_time" -u critical

    mail -s "some message subject" "$report_email" < /dev/null
fi

if [ -z "$record_file" ]; then
    echo "tis empty"
else
    echo "tis NOT empty!"
fi
#
#**************************#

# Make extra sure all processes are dead when script ends
pkill chromium && pkill chromedriver