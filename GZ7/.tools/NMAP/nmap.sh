#!/bin/bash
#NMAP
#Coded by Z3R07-RED

function new_nmap(){
$DIALOG --backtitle "$program_name - NMAP" --title "PORTS SCAN" \
      --prgbox "nmap -oN $log_directory/nmap.log -vv $NMAPN" 10 61

$DIALOG --backtitle "$program_name - NMAP" --title "NMAP" \
        --textbox "$log_directory/nmap.log" 15 61
}

NMAPN=$($DIALOG --backtitle "$program_name - NMAP" --title "PORTS SCAN" --inputbox "Write a website to scan" 10 51 3>&1 1>&2 2>&3)

case $? in
    0)
        new_nmap
        ;;

    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
