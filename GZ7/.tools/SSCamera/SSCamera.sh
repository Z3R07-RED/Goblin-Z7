#!/bin/bash
# SSCamera
# Coded by Z3R07-RED on Jul 8 2021
#
# VARIABLES:
termux_path="/data/data/com.termux/files/usr/bin"
kali_linux_path="/usr/bin"
# DIALOG=${DIALOG=dialog}


# Dependencies
function dependencies_sscamera(){
if [[ -d "$kali_linux_path" ]]; then
    APTT="apt-get"
else
    APTT="apt"
fi
tput civis; counter_dn=0

PKGS=(node npm) # dependencies
for program in "${PKGS[@]}"; do
    if [ ! "$(command -v $program)" ]; then
        let counter_dn+=1
        if [[ "$program" == "node" ]]; then
            program="nodejs"
        fi
        $DIALOG --clear --title "PACKAGE" \
            --timeout 2 \
            --prgbox "Install $program ..." "$APTT install $program -y" 12 60
    fi
done
tput cnorm
sleep 1
}

echo $(clear)
internet_connection
dependencies_sscamera

if [ "$(command -v npm)" ]; then
    $DIALOG --backtitle "$program_name - SSCamera" --title "" \
        --prgbox "Secret Security Camera ..." "npm run start" 15 60
else
    unexpected_error
fi


# Install PACKAGES
# npm install express socket.io
# npm install nodemon -D
