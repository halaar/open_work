#!/bin/bash


# Define current user
console_user="$(/usr/bin/stat -f%Su /dev/console)"

# Define and copy UUID
UUID=$(ioreg -rd1 -c IOPlatformExpertDevice | awk '/IOPlatformUUID/ { split($0, line, "\""); printf("%s\n", line[4]); }')

if [[ -n "$UUID" ]]; then
    # Remove offending keychain
    rm -rf /Users/"$console_user"/Library/Keychains/"$UUID"/
else
    echo "Unable to determine UUID."
fi

# Reset login.keychain to match new password
# Commented out by Nick Cobb on 10/6 due to users complaining of keychain issues/loss - Why was this included in the script?
# /usr/bin/security delete-keychain /Users/"$console_user"/Library/Keychains/login.keychain

exit 0
