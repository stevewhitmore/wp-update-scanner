"""Scans WordPress for updates and writes findings to file

Creates a list of string values representing information about the
needed updates. Those values are written to a text file which is then
consumed outside of this file to generate a notification
"""
import sys
import configparser
import datetime
from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import StaleElementReferenceException

OPTIONS = webdriver.ChromeOptions()
OPTIONS.add_argument('--ignore-certificate-errors')
OPTIONS.add_argument('--test-type')
OPTIONS.add_argument('--headless')
OPTIONS.binary_location = '/usr/bin/chromium-browser'

DRIVER = webdriver.Chrome(options=OPTIONS)

CONFIG = configparser.ConfigParser()
CONFIG.read('config.txt')

WEBSITE = sys.argv[1]

def run():
    """Kick off page scraping script"""
    record_file = CONFIG['FollowUp']['recordFile']
    clean_out_file_contents(record_file)

    log_into_wordpress()
    navigate_to_core_update_page()

    core_updates = scan_for_updates('core')
    plugin_updates = scan_for_updates('plugins')
    theme_updates = scan_for_updates('themes')
    update_data = core_updates + plugin_updates + theme_updates

    write_to_file(record_file, update_data)

    DRIVER.quit()


def clean_out_file_contents(record_file):
    """Wipe out update-data.txt file contents to to avoid misinformation"""
    open(record_file, 'w').close()


def log_into_wordpress():
    """Use configs to log into wordpress. This is needed for custom login urls"""
    username = CONFIG[WEBSITE]['username']
    password = CONFIG[WEBSITE]['password']
    login_url = CONFIG[WEBSITE]['loginUrl']
    if (not username or not password or not login_url):
        print('###### Invalid configs. Exiting... ######')
        exit()

    DRIVER.get(login_url)
    DRIVER.find_element_by_id('user_login').clear()
    DRIVER.find_element_by_id('user_login').send_keys(username)
    DRIVER.find_element_by_id('user_pass').clear()
    DRIVER.find_element_by_id('user_pass').send_keys(password)
    DRIVER.find_element_by_id('wp-submit').click()


def navigate_to_core_update_page():
    """Go to specific core update page"""
    update_page_xpath = '//*[@id="menu-dashboard"]/ul/li[3]/a'

    try:
        WebDriverWait(DRIVER, 10).until(
            EC.presence_of_element_located((By.XPATH, update_page_xpath)))

        DRIVER.get(CONFIG[WEBSITE]['updateUrl'])

    except StaleElementReferenceException as exception:
        raise exception


def scan_for_updates(section):
    """Create a list of string values which are titles of plugin items"""
    selector = determine_selector(section)
    update_element_list = DRIVER.find_elements_by_css_selector(selector)

    if update_element_list:
        plugin_update_element = update_element_list[0]

        if 'tbody' in selector:
            plugin_title_elements = plugin_update_element \
                                        .find_elements_by_css_selector('tbody tr td.plugin-title')
            plugin_update_data = []

            for title in plugin_title_elements:
                plugin_update_data.append(title.text)

            return plugin_update_data

        return [plugin_update_element.text]

    return []


def determine_selector(section):
    """Return specific selector value depending on input"""
    if section == 'core':
        selector = '#wpbody-content > div.wrap > ul.core-updates > li a'
    elif section == 'plugins':
        selector = '#update-plugins-table > tbody'
    elif section == 'themes':
        selector = '#update-themes-table > tbody'
    else:
        raise Exception('invalid argument passed to scan_for_updates')

    return selector


def write_to_file(output_file, update_data):
    """Write values of update data list to output file for notifications"""
    separator = '###################################################'
    now = datetime.datetime.now()
    now_formatted = now.strftime('%A, %B %d %Y at %H:%M:%S')

    with open(output_file, "a") as myfile:
        myfile.write(separator + "\n" + now_formatted + " --- "
                     + WEBSITE + "\n" + separator + "\n")
        for item in update_data:
            myfile.write(item + "\n\n")


run()
