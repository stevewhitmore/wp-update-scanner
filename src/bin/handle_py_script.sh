#!/bin/bash

website=$1

### Specify python path for container
PATH=$PATH:/usr/local/bin

run_scan_for_updates_script() {
    python ./scan_for_updates.py "$website"
}
error_output=$(run_scan_for_updates_script 2>&1)

pkill chromedriver

./bin/notify_errors.sh "$error_output" "$website"

exit
