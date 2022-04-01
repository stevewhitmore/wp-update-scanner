# Changelog fo WP Update Scanner

## 2.1.0
* Changed
  * Dockerized the application
  * Adjusted chromedriver setup to accomodate the Debian container environment
  * Updated `PATH` variable so `python` command would be recognized in container environment

## 2.0.0
* Breaking Changes
  * Directory structure changed to better fit the standards set by PyPA <https://packaging.python.org/en/latest/tutorials/packaging-projects/>

## 1.0.2
* Changed
  * The email content to specific error message instead of directing user to error log file

## 1.0.1
* Changed
  * The way the Chrome driver is instantiated by using the Service object instead of a straight path to the executable
  * The syntax used for selecting page elements
