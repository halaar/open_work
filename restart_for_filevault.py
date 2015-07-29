#!/usr/bin/env python

############### THIS SCRIPT HAS BEEN DEPRECATED AS OF 12/1/2014 ################

import subprocess
import time


# Path for JAMF Helper
jamfHelper = '/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper'


def is_app_running(app):
    count = int(subprocess.check_output(["osascript",
                                         "-e", "tell application \"System Events\"",
                                         "-e", "count (every process whose name is \"" + app + "\")",
                                         "-e", "end tell"]).strip())
    return count > 0


def main():
    description = 'The next step is enabling FileVault and securing your computer, which requires rebooting. Click OK to proceed.'
    jamf_helper = '/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper'

    response = None
    try:
        response = subprocess.check_call([jamf_helper,
                                          '-windowType',
                                          'utility',
                                          '-lockHUD',
                                          '-button1'
                                          '"OK"',
                                          '-description',
                                          '%s' % description,
                                          '-button1',
                                          '"OK"'])
        if response == 0:
            apps_to_kill = ['firefox', 'Safari', 'Google Chrome']
            for app in apps_to_kill:
                if is_app_running(app):
                    try:
                        proc = subprocess.Popen(['/usr/bin/killall', '%s' % app])
                        (out, err) = proc.communicate()
                        if proc.returncode != 0:
                            print('An error occurred when attempting to quit %s. Error: %s' % (app, err))
                    except OSError as e:
                        print('An error occurred when attempting to quit %s. Error: %s' % (app, e))
            time.sleep(5)
            subprocess.check_output('osascript -e \'tell app "System Events" to restart\'', shell=True)
            subprocess.check_output('kill $(pgrep jamfHelper)', shell=True)

    except subprocess.CalledProcessError, e:
        print('An error occurred when attempting to run jamfHelper.\nReturn code: %s\nError: %s' % (e.returncode, e))


if __name__ == '__main__':
    main()
