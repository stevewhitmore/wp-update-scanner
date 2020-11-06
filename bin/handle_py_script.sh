#!/bin/bash

website=$1

run_scan_for_updates_script() {
    python3 ../scripts/scan_for_updates.py "$website"
}
error_output=$(run_scan_for_updates_script 2>&1)

pkill chromedriver

./notify_errors.sh "$error_output" "$website"

exit
