#!/bin/bash

report_email=$(awk -F= '/email/ { print $2 }' config.txt)
record_file=$(awk -F= '/recordFile/ { print $2 }' config.txt)

if [ -n "$record_file" ]; then
    mail -s "WordPress Updates Needed" "$report_email" < "$record_file"
fi

exit
