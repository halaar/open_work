#!/bin/bash

exec 2>&1

if [ $EUID -ne "0" ]; then
    echo "This script must run as root. Exiting now."
    exit 1
fi

grep="/usr/bin/grep"
fdesetup="/usr/bin/fdesetup"

clientadmin="clientadmin"
clientadministrator="clientadministrator"

fileVaultEnabled=`$fdesetup status | $grep "FileVault is On"`
ZDadminCanUnlock=`$fdesetup list | $grep $ZDadmin`
clientadminCanUnlock=`$fdesetup list | $grep $clientadmin`
clientadministratorCanUnlock=`$fdesetup list | $grep $clientadministrator`

if [ "${#fileVaultEnabled}" == "0" ]; then
    echo "FileVault is either disabled or busy. Exiting now."
    exit 1
else
    if [ "${#ZDadminCanUnlock}" == "0" ] || [ "${#clientadminCanUnlock}" == "0" ] || [ "${#clientadministratorCanUnlock}" == "0" ]; then
        $fdesetup add -inputplist < /private/tmp/fdesetup_add_local_admin.plist
    else
        echo "All local admins can already unlock the disk."
    fi
fi

exit $?
