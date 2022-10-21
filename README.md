# WP Update Scanner

As an administrator of several WordPress websites I wanted a way to be notified whenever one of them had plugin, theme, or core updates.
This project allows me to scan several websites without adding to the bloat which most WordPress installations struggle with. Instead of creating and installing a custom plugin on each website I can run the executable in this project and target whichever website I want to scan for updates.

### How does it work?

This project is intended to run as a cron job. The Bash script `run.sh` kicks off a Python script which uses the Selenium library to headlessly log into the WordPress admin page. From there it navigates to the core updates page, scans it for update notifications, then writes it to a temporary file. The Bash scripts check for errors outputted by the Python script, writes the errors to a log file, and notifies the user. If the Python script runs as expected the "notify_updates.sh" script will send the information stored in the temporary file to the user.

When deployed this project will run every night at midnight local US Central time.

### How do I use it?

You'll want to set up your `config.txt` and add a `.muttrc` file in the root directory of this project. This application works best in a Docker environment. I recommend you install it on the host machine if you don't have it installed already. More information on that [here](https://docs.docker.com/engine/install/).

1. Rename the `config.template.txt` file to `config.txt` and replace the values as needed. 
2. Add a `.muttrc` file to the root directory of this project for the email notifications. Information on sending files via Google SMTP can be found [here](https://github.com/stevewhitmore/notes/blob/master/linux/gmail-smtp-bash.md).
3. From the root directory of this project run `docker build -t wp-scan .` to build the image. There is no prebuilt image available to pull because it needs files with sensitive information that is custom per user.
4. Run `docker run -d --name wp-update-scanner wp-scan` to run the container. You shouldn't need to expose any ports since there's no need to interact with the container.
5. If needed, you can SSH into the container with `docker exec -it wp-update-scanner /bin/bash` to adjust things without having to rebuild the image.

It's also possible to run this without Docker. See below requirements for details.

### Requirements

* Docker

OR

* Python v3.10.3
  * selenium v4.1.3
* Bash
    * mutt
    * cron
* chromedriver and chrome/chromium v99
