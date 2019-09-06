#!/bin/bash

website=$1

run_scan_for_updates_script() {
    python3 ./scan_for_updates.py "$website"
}
error_output=$(run_scan_for_updates_script 2>&1)

./notify_of_results.sh "$error_output"
