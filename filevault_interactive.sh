#!/bin/bash

###
#
#            Name:  client_filevault_interactive.sh
#     Description:  This script checks whether FileVault is enabled. If not, it
#                   prompts the user to restart. Intended to be used in a
#                   Casper policy that enables FileVault 2 encryption.
#
###

jamfHelper=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper

FILEVAULT_STATUS=$(/usr/bin/fdesetup status | grep "FileVault is ")

# If parameter 4 is set, use it to determine whether to require restart
if [[ $4 == "true" || $4 == "false" ]]; then
    MANDATORY_RESTART="$4"
else
    echo "Warning: Parameter 4 in this policy should be set to true or false."
    MANDATORY_RESTART="false"
fi

# Install client stash, if it isn't already installed, so we can use logos in prompt.
/usr/sbin/jamf policy -trigger client-stash

if [[ $FILEVAULT_STATUS == "FileVault is On." ]]; then

    # If FV is already on, only require restart if the policy settings specify so.
    echo "FileVault is already on."
    if [[ $MANDATORY_RESTART == "true" ]]; then
        echo "Restart is required, according to the policy settings. Prompting user to restart now..."
        $jamfHelper -windowType hud -lockHUD -windowPosition ur -icon "/Library/client/Resources/client_Logotype_Digital_White.png" -heading "Restart required" -description "In order to finish enrollment, your computer needs to restart. Please save your work, quit open apps, and choose Restart from the Apple menu." -startlaunchd -button1 "OK, I will" -defaultButton "1"
    else
        echo "Restart is not required, according to the policy settings."
    fi

else

    # If FV is off, require restart in order to enable FV.
    echo "FileVault is not on. Prompting user to restart in order to enable encryption..."
    $jamfHelper -windowType hud -lockHUD -windowPosition ur -icon "/Library/client/Resources/client_Logotype_Digital_White.png" -heading "Restart required" -description "In order to enable encryption, your computer needs to restart. Please save your work, quit open apps, and choose Restart from the Apple menu. Enter your Mac login password when prompted." -startlaunchd -button1 "OK, I will" -defaultButton "1"

fi

exit 0