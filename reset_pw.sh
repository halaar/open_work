#!/usr/bin/env bash

############### THIS SCRIPT HAS BEEN DEPRECATED AS OF 12/1/2014 ################

PW="tech"
USER="client"

/usr/bin/dscl . passwd "/Users/$USER" "$password"

exit 0
