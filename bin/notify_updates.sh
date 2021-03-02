#!/bin/bash

report_email=$(awk -F= '/email/ { print $2 }' ../config.txt)
record_file=$(awk -F= '/recordFile/ { print $2 }' ../config.txt)

if [[ -s "$record_file" ]]; then
    mutt -s "wp-update-scanner: WordPress Updates Needed" "$report_email" < "$record_file"
else
    echo "Scan complete. No updates needed." | mutt -s "wp-update-scanner: No updates" "$report_email"
fi

exit
