#!/bin/sh

############### THIS SCRIPT HAS BEEN DEPRECATED AS OF 12/1/2014 ################

exec 2>&1

mkdir="/bin/mkdir"
touch="/usr/bin/touch"

console_user="$(/usr/bin/stat -f%Su /dev/console)"
receipts_dir="/Library/Application Support/.ClientTechServices"
can_update_screensaver_prefs="canUpdateScreenSaverPrefs"

if [[ ! -d "$receipts_dir" ]]; then
    $mkdir -p "$receipts_dir"
else
    echo "$receipts_dir already exists."
fi

if [[ $? == 0 ]]; then
    $touch "$receipts_dir/$can_update_screensaver_prefs"
else
    echo "An error occured when attempting to create $receipts_dir/$can_update_screensaver_prefs"
fi

su "$console_user" -c '/usr/bin/defaults -currentHost write com.apple.screensaver idleTime 600'
su "$console_user" -c '/usr/bin/defaults write com.apple.screensaver askForPassword 1'
su "$console_user" -c '/usr/bin/defaults write com.apple.screensaver askForPasswordDelay -int 300'

exit $?
