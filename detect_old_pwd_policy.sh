#!/bin/sh

###
#
#            Name:  client_detect_old_pwd_policy.sh
#     Description:  This Casper extension attribute will detect whether an old
#                   version of the pwpolicy is set. If so, the computer will be
#                   scoped into a Casper policy that will clear the pwpolicy.

###

# Set to false by default. (Innocent until proven guilty.)
RESULT="False"

# Getting global password policy...
POLICY="$(/usr/bin/pwpolicy -getglobalpolicy | awk -F "maxMinutesUntilChangePassword=" '{print $2}' | awk '{print $1}')"
if [[ "$POLICY" -gt 0 ]]; then
    RESULT="True"
fi

USERS=/Users/*
for USER in $USERS; do
    if [[ $(basename $USER) != "Shared" && $(basename $USER) != "Guest" ]]; then

        # Getting password policy for user...
        POLICY="$(/usr/bin/pwpolicy -u "$(basename $USER)" -getpolicy | awk -F "maxMinutesUntilChangePassword=" '{print $2}' | awk '{print $1}')"
        if [[ "$POLICY" -gt 0 ]]; then
            RESULT="True"
        fi

    fi
done

echo "<result>$RESULT</result>";

exit 0