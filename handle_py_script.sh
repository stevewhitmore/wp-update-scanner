#!/bin/bash

website=$1

run_update_scanner_script() {
    python3 ./update_scanner.py "$website"
}
error_output=$(run_update_scanner_script 2>&1)

./results_notify.sh "$error_output"
