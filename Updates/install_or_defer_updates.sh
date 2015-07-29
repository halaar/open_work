#!/bin/bash
#
###


############################# PATHS AND VARIABLES ##############################

# The plist file that is used to store settings locally. Omit ".plist" extension.
CASPER_PLIST="/Library/ClientName/com.clientnameinternal.casper"

# The logo that will be used in messaging. Recommend 512px square, PNG format.
LOGO="/Library/ClientName/Resources/ClientName_Logotype_Digital_White.png"

# The message users will receive when updates are available.
# %DEFERRALS% will be automatically replaced by the number of deferrals remaining.
MSG_INSTALL_OR_DEFER_HEADING="Critical updates are available"
MSG_INSTALL_OR_DEFER="Apple has released critical security updates that need to be installed ASAP. Please save your work, quit all apps, and click Install Now. You will need to restart after the updates are installed.

You may defer this message %DEFERRALS% more times before your Mac automatically installs the updates and restarts.

Please email it@clientname.com if you have questions."

# The message users will receive when updates are installing.
MSG_INSTALLING_UPDATES_HEADING="Critical updates installing now"
MSG_INSTALLING_UPDATES="Please do not turn off your Mac or close the lid. You will need to restart your Mac when the updates are finished installing.

If this message remains for longer than 20 minutes, please contact ClientName Tech Services at it@clientname.com."

# The message users will receive when updates are finished.
# Note: We are assuming a restart is required, because deploying critical
# updates that don't require a restart does not require install/defer process.
MSG_UPDATES_DONE_PLEASE_RESTART_HEADING="Please restart now"
MSG_UPDATES_DONE_PLEASE_RESTART="The updates were installed, and your Mac needs to restart. Please save your work and choose Restart from the Apple menu now."

# Shell executable paths.
defaults=/usr/bin/defaults
echo=/bin/echo
jamf=/usr/sbin/jamf
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
killall=/usr/bin/killall
sleep=/bin/sleep
softwareupdate=/usr/sbin/softwareupdate


######################## VALIDATION AND ERROR CHECKING #########################

# Currently logged-in user.
USER=$(/usr/bin/stat -f%Su /dev/console)

$echo "Checking for an existing AppleSoftwareUpdateDeferrals value..."
DEFERRALS_REMAINING=$($defaults read "$CASPER_PLIST" AppleSoftwareUpdateDeferrals 2> /dev/null)
if [[ "$?" != "0" ]]; then
    $echo "No AppleSoftwareUpdateDeferrals value found. Setting to maximum deferrals..."
    if [[ -n $4 ]]; then
        # Parameter 4 is set, so we'll use that for maximum deferrals.
        DEFERRALS_REMAINING=$4
    else
        # Parameter 4 is not set, so we'll set 3 maximum deferrals.
        DEFERRALS_REMAINING=3
    fi
fi

if [[ ! -f "$LOGO" ]]; then
    $echo "Error: $LOGO does not exist." >&2
    exit 1001
fi

if [[ ! -x "$jamf" ]]; then
    $echo "Error: $jamf does not exist or is not executable." >&2
    exit 1002
fi


################################## FUNCTIONS ###################################

# This function installs updates immediately after the user clicks Install Now,
# or after the deferrals run out.
fn_InstallAllUpdates ()
{
    $echo "Displaying \"updates in progress\" message..."
    "$jamfHelper" -windowType "hud" -lockHUD -windowPosition "ur" -icon "$LOGO" -heading "$MSG_INSTALLING_UPDATES_HEADING" -description "$MSG_INSTALLING_UPDATES" -startlaunchd &

    $echo "Installing all available software updates..."
    $softwareupdate --install --all
    $sleep 5

    $echo "Deleting the AppleSoftwareUpdateDeferrals value..."
    $defaults delete "$CASPER_PLIST" AppleSoftwareUpdateDeferrals 2> /dev/null

    $echo "Updates finished."
    $killall jamfHelper 2> /dev/null

    # Display prompt asking user to restart.
    $echo "Displaying \"please restart\" message..."
    "$jamfHelper" -windowType "hud" -lockHUD -windowPosition "ur" -icon "$LOGO" -heading "$MSG_UPDATES_DONE_PLEASE_RESTART_HEADING" -description "$MSG_UPDATES_DONE_PLEASE_RESTART" -startlaunchd &
}


################################# MAIN PROCESS #################################

# Start downloading updates, to minimize wait time later.
$softwareupdate -d

if [[ "$USER" == "root" ]]; then

    # If nobody is logged in, install updates.
    $echo "Nobody is logged in. Installing updates now..."
    fn_InstallAllUpdates

elif (( DEFERRALS_REMAINING == 0 )); then

    # If no deferrals remain, install updates.
    $echo "No more deferrals. Installing updates now..."
    fn_InstallAllUpdates

elif (( DEFERRALS_REMAINING > 0 )); then

    # If deferrals remain, prompt user to install or defer.
    $echo "Prompting user to install or defer..."
    $killall jamfHelper 2> /dev/null
    PROMPT="$("$jamfHelper" -windowType hud -lockHUD -icon "$LOGO" -heading "$MSG_INSTALL_OR_DEFER_HEADING" -description "$(echo "$MSG_INSTALL_OR_DEFER" | sed "s/%DEFERRALS%/$DEFERRALS_REMAINING/g")" -button1 "Install Now" -button2 "Defer" -defaultButton 1 -startlaunchd)"

    if [[ "$PROMPT" == "0" ]]; then

        $echo "User clicked Install Now."
        fn_InstallAllUpdates

    else

        $echo "User deferred. $(( DEFERRALS_REMAINING - 1 )) deferrals now remaining."
        $defaults write "$CASPER_PLIST" AppleSoftwareUpdateDeferrals "$(( DEFERRALS_REMAINING - 1 ))"

    fi

fi

exit 0
