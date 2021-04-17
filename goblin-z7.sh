#!/bin/bash
#goblin-z7
#Coded by Z3R07-RED on Nov 5 2020
#UPDATED: 2021
#<https://github.com/Z3R07-RED/Goblin-Z7.git>

#colors
source GZ7/colors
#
#VARIABLES:
DIALOG=${DIALOG=dialog}
SHOW_REGISTER="True"

if [[ -f "GZ7/goblin_variables" && -f "GZ7/goblin_functions" ]]; then
    source GZ7/goblin_variables
    source GZ7/goblin_functions
else
    echo "[ERROR]: ! files ..."
    echo "";exit 0
fi

if [[ -f "$config_directory/goblin.conf" ]]; then
    source "$config_directory/goblin.conf"
else
    file_not_found "goblin.conf"
fi

if [[ -f "$config_directory/themes/$THEME" ]]; then
    export DIALOGRC=$config_directory/themes/$THEME
fi

if [[ ! -d "$log_directory" ]]; then
    mkdir "$log_directory"
fi

if [[ ! -d "$tmp_directory" ]]; then
    mkdir "$tmp_directory"
fi

#CTRL+C
trap ctrl_c INT

function ctrl_c(){
echo $(clear)
rm -rf tmp/* 2>/dev/null
rm -rf logs/* 2>/dev/null
rm -rf "$DISKDIGGERT" 2>/dev/null
echo "Program aborted."
tput cnorm
echo "";exit 1
}

#FUNCTIONS:
# special dependencies
function special_dependencies(){
if [[ -d "$termux_path" ]]; then
    if [ ! "$(command -v tput)" ]; then
        echo -e "\n${Y}[I]${W} apt install ncurses-utils ...${W}"
        apt install ncurses-utils -y >/dev/null 2>&1
        sleep 1
    fi

    if [ ! "$(command -v proxychains4)" ]; then
        echo -e "\n${Y}[I]${W} apt install proxychains-ng ...${W}"
        apt install proxychains-ng -y >/dev/null 2>&1
        sleep 1
    fi
    PROXYCHAINS="proxychains4"
    if [[ ! -f $PREFIX/etc/proxychainsg.old ]]; then
        cat $PREFIX/etc/proxychains.conf > $PREFIX/etc/proxychainsg.old 2>/dev/null
        cat GZ7/.CS07/proxychains.conf > $PREFIX/etc/proxychains.conf 2>/dev/null
    fi
fi

if [[ -d "$kali_linux_path" ]]; then
    if [[ ! -f "$log_directory/libsox_fmt_all.txt" ]]; then
        touch "$log_directory/libsox_fmt_all.txt"
        if [ ! "$(command -v libsox-fmt-all)" ]; then
            echo -e "\n${Y}[I]${W} apt-get install libsox-fmt-all ...${W}"
            apt-get install libsox-fmt-all -y >/dev/null 2>&1
            sleep 0.5
        fi
    fi

    if [ ! "$(command -v ifconfig)" ]; then
        echo -e "\n${Y}[I]${W} apt-get install net-tools ...${W}"
        apt-get install net-tools -y >/dev/null 2>&1
        sleep 0.5
    fi

    if [ ! "$(command -v proxychains)" ]; then
        echo $(clear)
        echo -e "\n${Y}[I]${W} sudo apt-get install proxychains ...${W}"
        exit 1
    fi
    PROXYCHAINS="proxychains"
    if [[ ! -f /etc/proxychainsg.old ]]; then
        cat /etc/proxychains.conf > /etc/proxychainsg.old 2>/dev/null
        cat GZ7/.CS07/proxychains.conf > /etc/proxychains.conf 2>/dev/null
    fi
fi
}
# dependencies
function dependencies(){
special_dependencies
tput civis; counter_dn=0
echo $(clear);sleep 0.3
dependencies=(dialog git curl wget w3m sox nmap tor file zip) # dependencies
for program in "${dependencies[@]}"; do
    if [ ! "$(command -v $program)" ]; then
        echo -e "\n${R}[X]${W}${C} $program${Y} is not installed.${W}";sleep 0.2
        echo -e "\n\e[1;33m[i]\e[0m${C} Installing ...${W}";sleep 0.6
        apt-get install $program -y > /dev/null 2>&1
        echo -e "\n\e[1;32m[V]\e[0m${C} $program${Y} installed.${W}";sleep 1
        let counter_dn+=1
    fi
done
if [[ $counter_dn != 0 ]]; then
    echo -e "\n\e[1;36m$program_name - version $version\e[0m"
    echo -e "\n\e[1;32mCoded by Z3R07-RED on Nov 5 2020\e[0m"
    sleep 2; echo $(clear)
fi
}

##################################################################
#Extract links
function extract_links(){
tput cnorm
web_extract_links=$($DIALOG --stdout --clear --backtitle "$program_name - Extract links" \
        --title "[WEBSITE]" \
        --inputbox "Website:" 10 60)

case $? in
    0)
        if [[ -n $web_extract_links ]]; then
            tput civis
            #$DIALOG --backtitle "$program_name - Extract links" --title "[WEBSITE]" --prgbox "curl https://api.hackertarget.com/pagelinks/?q=$web_extract_links > $log_directory/extracted_links.log" 12 60
            $PROXYCHAINS curl https://api.hackertarget.com/pagelinks/?q=$web_extract_links > $log_directory/extracted_links.log 2>/dev/null
            $DIALOG --exit-label "Ok" --backtitle "$program_name - $log_directory/extracted_links.log" --title "Extracted Links" --textbox $log_directory/extracted_links.log 15 60
        else
            unexpected_error
        fi
        ;;
    1)
        tput civis
        sleep 0.3
        ;;
    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
}

# Downloaded Website
function wdownload(){
tput cnorm
download_website=$($DIALOG --stdout --clear --backtitle "$program_name - Download Website" \
        --title "[WEBSITE]" \
        --inputbox "Website:" 10 60)

case $? in
    0)
        if [[ -n $download_website ]]; then
            select_a_directory
            if [[ -n $chosen_directory ]]; then
                $DIALOG --backtitle "$program_name - Download Website" --title "[DOWNLOADING]" --prgbox "$PROXYCHAINS wget -P $chosen_directory -r -l 2 -k $download_website" 12 60
                $DIALOG --backtitle "$program_name - Download Website" --title "[WEBSITE]" --prgbox "echo Downloaded website:; ls -a $chosen_directory" 12 60
            fi
            tput civis
        else
            unexpected_error
        fi
        ;;
    1)
        tput civis
        sleep 0.3
        ;;
    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
}

#PhoneNumbersCS07
function phonenumbersCS07(){
tput cnorm
$DIALOG --backtitle "$program_name - PhoneNumbersCS07" \
    --title "PHONE NUMBER" \
    --inputbox "Enter phone number:" 10 50 "+591" 2>"${phone_numbers_CS07_file}"

case $? in
    0)
        if [[ -f "$phone_number_infor_file" ]]; then
            rm "$phone_number_infor_file" 2>/dev/null
            touch "$phone_number_infor_file"
        else
            touch "$phone_number_infor_file"
        fi
        if [[ -s $phone_numbers_CS07_file ]]; then
            if [[ ! -x "$phonenumbersCS07_tool" ]]; then
                chmod +x "$phonenumbersCS07_tool"
            fi
            python3 "$phonenumbersCS07_tool" &
            $DIALOG --clear --backtitle "$program_name - PhoneNumbersCS07" \
                --title "[INFO]" \
                --tailbox "$phone_number_infor_file" 10 60

            rm "$phone_numbers_CS07_file" 2>/dev/null
            # rm "$phone_number_infor_file" 2>/dev/null
            sleep 0.3
        else
            unexpected_error
        fi
        ;;

    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo ""; exit 1
        ;;
esac
tput civis
}

# Shorten URL
function shorten_url(){
tput cnorm
SHORTEN=$($DIALOG --stdout --backtitle "$program_name - Shorten URL" --title "SHORTEN URL" --inputbox "Enter a long URL to make a TinyURL:" 10 51)

case $? in
    0)
        $DIALOG --backtitle "$program_name - Shorten URL" \
                --title "CUT URL" \
                --prgbox "echo Your long URL:; echo $SHORTEN; echo; echo TinyURL:; curl -s http://tinyurl.com/api-create.php?url=$SHORTEN" 10 51
        ;;

    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo ""; exit 1
        ;;
esac
tput civis
}

#RED TOOLS MENU
function red_tools_zmenu(){
while :
do
    red_toolsz_option=$($DIALOG --stdout --item-help \
        --ok-label "Select" \
        --backtitle "$program_name - Red tools Z7" \
        --title "MENU" \
        --menu "Powerful tools:" 13 45 5 \
        "1" "[ Email-RedZ       ]" "Tool to impersonate any email." \
        "2" "[ Extract links    ]" "Extract all links from a web page?" \
        "3" "[ Download website ]" "Do you want to download a website?" \
        "4" "[ Shorten URL      ]" "cut a url very fast." \
        "5" "[ PhoneNumbersCS07 ]" "Get information from a phone number.")

    case $red_toolsz_option in
        1)
            source $email_redz_tool
            ;;
        2)
            extract_links
            ;;
        3)
            wdownload
            ;;
        4)
            shorten_url
            ;;
        5)
            phonenumbersCS07
            ;;
        *)
            break
            ;;
    esac

done
}

# Settings
function goblin_settings(){
while :
do
SETTINGS=$($DIALOG --stdout --backtitle "$program_name - Settings" \
                   --ok-label "Select" --cancel-label "Back" \
                   --title "Settings" \
                   --menu "" 10 45 3 \
                    1 "[ PROFILE ]" \
                    2 "[ THEMES  ]" \
                    3 "[ ABOUT   ]")

case $? in
    0)
        if [[ $SETTINGS == 1 ]]; then
            SHOW_REGISTER=""
            source GZ7/.CS07/security/.sec
        elif [[ $SETTINGS == 2 ]]; then
            while :
            do
            THEMES_LIST=$(find "$config_directory/themes" -mindepth 1 -maxdepth 1 -type f -not -name '.*' -printf "%f %TY-%Tm-%Td\n");
            THEME_SETTING=$($DIALOG --stdout --backtitle "$program_name - Settings" \
                                    --title "THEMES" \
                                    --ok-label "Select" --cancel-label "Back" \
                                    --menu "" 12 45 5 $THEMES_LIST --output-fd 1)

            case $? in
                0)
                    sed -i "s/THEME=\"$THEME\"/THEME=\"$THEME_SETTING\"/g" "$config_directory/goblin.conf" 2>/dev/null
                    TMESTTG="$THEME_SETTING"
                    THEME="$TMESTTG"
                    export DIALOGRC=$config_directory/themes/$THEME_SETTING
                    $DIALOG --backtitle "$program_name - Themes" \
                            --title "Settings" \
                            --no-collapse \
                            --msgbox "The theme of the program was configured correctly." 8 51
                    ;;
                1)
                    break
                    ;;

                255)
                    echo $(clear)
                    echo "Program aborted." >&2
                    exit 1
                    ;;
            esac
            done
        elif [[ $SETTINGS == 3 ]]; then
            $DIALOG --backtitle "$program_name" \
                    --title "ABOUT" \
                    --textbox "GZ7/.CS07/about" 15 55
        else
            unexpected_error
        fi
        ;;

    1)
        break
        ;;

    255)
        echo $(clear);tput cnorm
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
done
}

#MAIN-MENU OPTIONS
function goblin_options(){
if [[ "$main_menu" == 1 ]]; then
    red_tools_zmenu
elif [[ "$main_menu" == 2 ]]; then
    tput cnorm
    if [[ -f "$creator_tool" ]]; then
        source "${creator_tool}"
    else
        file_not_found "$creator_tool"
    fi
    tput civis
elif [[ "$main_menu" == 3 ]]; then
    tput cnorm
    if [[ -f "${TubeVide07_tool}/TubeVide07.sh" ]]; then
        source "${TubeVide07_tool}/TubeVide07.sh"
        tput civis
    else
        file_not_found "TubeVide07.sh"
    fi

elif [[ "$main_menu" == 4 ]]; then
    if [[ -f "$DiggerSC_tool/DiggerSC" ]]; then
        if [[ -f "$DiggerSC_tool/DiskDigger" ]]; then
            cat "$DiggerSC_tool/DiskDigger" > "$DISKDIGGERT"
            chmod +x "$DISKDIGGERT"
            source "$DiggerSC_tool/DiggerSC"
        else
            file_not_found "DiskDigger"
        fi
    else
        file_not_found "DiggerSC"
    fi
elif [[ "$main_menu" == 5 ]]; then
    tput cnorm
    source "${nmap_tool}"
    tput civis

elif [[ "$main_menu" == 6 ]]; then
    tput cnorm
    if [[ -f "${converter_tool}/converter.sh" ]]; then
        source "${converter_tool}/converter.sh"
        tput civis
    else
        file_not_found "converter.sh"
    fi

elif [[ "$main_menu" == 7 ]]; then
    if [[ -f "$system_information_file" ]]; then
        source "$system_information_file"
    else
        file_not_found "system_information"
    fi

elif [[ "$main_menu" == 8 ]]; then
    tput cnorm
    goblin_settings
    tput civis
fi
}

#MAIN-MENU
function goblin_menu_options(){
while :
do
    main_menu=$($DIALOG --stdout --help-button --item-help \
        --ok-label "Select" --cancel-label "Exit" \
        --backtitle "$program_name" \
        --title "MAIN-MENU" \
        --menu "$version" 15 51 6 \
        "1" "Red tools Z7        [ Hacking       ]" "Powerful tools." \
        "2" "Creator-G7          [ New tool      ]" "Start a new project." \
        "3" "TubeVide07          [ Audio/Video   ]" "Download videos and audios." \
        "4" "DiggerSC            [ File Digger   ]" "Copy all the files from a disk or usb." \
        "5" "Nmap                [ Port scan     ]" "Scan ports with nmap" \
        "6" "Text to audio       [ converter     ]" "Convert text to MP3 audio?" \
        "7" "System Information  [ Information   ]" "Show system information" \
        "8" "Settings            [ Settings      ]" "Configuration of '$program_name'")

case $? in
    0)
        goblin_options
        ;;
    1)
        echo $(clear);tput cnorm
        echo "Exiting ..."
        echo "";exit 0
        ;;
    2)
        $DIALOG --colors --backtitle "$program_name - version $version" \
            --no-collapse \
            --title "HELP" --msgbox "\Z0\Zb\Zu$program_name (c) 2020-2021 by Z3R07-RED\Zn\n\
A wide variety of powerful tools.\n\
* Use it at your own risk.\n\
* Do not misuse this program.\n\
* For your safety,\n\
use a VPN every time you run this program.\n\
\Z4\Zb\Zu<https://github.com/Z3R07-RED/Goblin-Z7.git>\Zn" 13 51
         ;;
     255)
         echo $(clear);tput cnorm
         echo "Program aborted." >&2
         echo "";exit 1
         ;;
esac
done
}

dependencies
give_permissions
tput cnorm
if [[ -f GZ7/.CS07/security/.sec ]]; then
    source GZ7/.CS07/security/.sec
else
    file_not_found ".sec"
fi
let try=1
while :
do
PASSWORD01=$($DIALOG --ok-label "Log In" --colors --extra-button --extra-label "About" --backtitle "\Zr$program_name - v$version\Zn Club Secreto 07" \
                    --clear --title "[$USERNAME]" --insecure --passwordbox "Password:" 10 55 3>&1 1>&2 2>&3)

case $? in
    0)
        if [[ "$PASSWORD01" == "$PASSWRD" ]]; then
            let try=0
            internet_connection
            tor_connection
            tput civis
            goblin_menu_options

        else
            $DIALOG --backtitle "$program_name - Security" \
                    --colors --title "[SECURITY]" \
                    --msgbox "Access denied! (try $try-3)\n\n\Z1\Zr[INCORRECT]:\Zn PASSWORD" 8 41

            if [ $try = 3 ]; then
                ANSWER02=$($DIALOG --stdout --backtitle "$program_name - Security Question" \
                        --title "[QUESTION]" \
                        --cancel-label "Exit" \
                        --ok-label "Submit" \
                        --inputbox "$QUESTION" 10 55)
                QUEST=$?
                case $QUEST in
                    0)
                        if [[ "$ANSWER" == "$ANSWER02" ]]; then
                            let try=0
                            internet_connection
                            tor_connection
                            tput civis
                            goblin_menu_options
                        else
                            echo $(clear)
                            echo -e "${R}Wrong answer.${W}"
                            echo ""
                            exit 1
                        fi
                        ;;
                    1)
                        echo $(clear)
                        echo "Exiting ..."
                        exit 0
                        ;;
                    255)
                        echo $(clear)
                        echo "Program aborted." >&2
                        exit 1
                        ;;
                esac
            else
               let  try=$(($try+1))
            fi
        fi
        ;;
    1)
        echo $(clear)
        echo "Exiting ..."
        exit 0
        ;;
    3)
        $DIALOG --backtitle "$program_name" \
                --title "ABOUT" \
                --textbox "GZ7/.CS07/about" 15 55
        ;;
    255)
        echo $(clear)
        echo "Program aborted." >&2
        exit 1
        ;;
esac
done
