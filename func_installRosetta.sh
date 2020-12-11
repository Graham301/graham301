#!/bin/bash


#   This script was written to allow users to install rosetta on systems equipped
#   with an apple processor from JAMF Self Service.


function installRosetta() {

    IFS='.' read OS_MAJOR OS_MINOR OS_DOT <<< "$(/usr/bin/sw_vers -productVersion)"

    #   verify big sur or greater
    if [[ ${OS_MAJOR} -ge 11 ]]; then

        #   get processor type
        PROCESSOR=$(/usr/sbin/sysctl -n machdep.cpu.brand_string | grep -o "Intel")

        #   if processor not Intel . . .
        if [[ -z "$PROCESSOR" ]]; then

            #   then check for rosetta launch daemon
            if [[ ! -f "/Library/Apple/System/Library/LaunchDaemons/com.apple.oahd.plist" ]]; then

                #   if no rosetta launch daemon then install rosetta
                if ! /usr/sbin/softwareupdate --install-rosetta --agree-to-license; then
                    echo "ERROR: Failed to install Rosetta." >&2
                    return $LINENO
                fi
            fi
        fi
    fi
}


function main() {

    installRosetta
}


if [[ "$BASH_SOURCE" == "$0" ]]; then
  main $@
  exit
fi
