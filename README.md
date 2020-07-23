# WP Update Scanner

As an administrator of several WordPress websites I wanted a way to be notified whenever one of them had plugin, theme, or core updates.
This project allows me to scan several websites without adding to the bloat which most WordPress installations struggle with. Instead of creating and installing a custom plugin on each website I can run the executable in this project and target whichever website I want to scan for updates.

### How does it work?

This project is intended to run as a cron job. The Bash script kicks off a Python script which uses the Selenium library to [headlessly](https://en.wikipedia.org/wiki/Headless_browser) log into the WordPress admin page. From there it navigates to the core updates page, scans it for update notifications, then writes it to a temporary file. The Bash scripts check for errors outputted by the Python script, writes the errors to a log file, and notifies the user. If the Python script runs as expected the "notify_updates.sh" script will send the information stored in the temporary file to the user.

`0 0 * * * cd /path/to/project; start.sh # run script every day at midnight`

### Requirements

* Python v3
* pip
* selenium
* chromium-browser
    * OPTIONS.binary_location will need to be changed if non-Linux OS is running this script
* Bash
* mutt

See [Send Email via Gmail SMTP Server](https://gist.github.com/stevewhitmore/79a459b414d89869708eaff4282097e2) to use your Gmail account for the notification emails (avoids spam filter issues).
