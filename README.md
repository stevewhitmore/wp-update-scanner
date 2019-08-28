# WP Update Scanner
WordPress installations get bloated when a plugin is installed for each and every feature.
I started developing a set of scripts to work independently of the website and scan the website once a week. If any updates pop up I'll get notified about it.

### How does it work?
This project is intended to run as a cron job. The bash script kicks off a Python script, which uses Python's Selenium library to log into the WordPress admin page. From there it navigates to the core updates page, scans it for update notifications, then writes it to a temporary file. The bash script checks for errors outputted by the Python script, writes the errors to a log file, and notifies the user. If the Python script has an ok return value the bash script will send the information about the WordPress updates needed to the user.

```
0 0 * * * cd /path/to/project; run.sh # run script every day at midnight
````

### Requirements
* Python v3
* pip
* selenium
* chromium-browser
    * OPTIONS.binary_location will need to be changed if non-Linux OS is running this script
* bash
* mailx

### \*\*\* TODOs \*\*\*
* Extend to allow for multiple website configs to be called based on arguments passed to **run.sh**