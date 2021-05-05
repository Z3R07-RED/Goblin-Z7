#!/bin/bash
# TEXT TO SPEECH
# Coded by Z3R07-RED on Dec 23 2020
# UPDATED: 2021


current_tool_name="TEXT TO AUDIO"
DIALOG=${DIALOG=dialog}
text_file="$tmp_directory/text.txt"
audio_created="$tmp_directory/audiocreated.tmp"
audio_file_name="$tmp_directory/audio_name.txt"

if [[ -f "$text_file" ]]; then
    rm "${text_file}" 2>/dev/null
    touch "${text_file}"
    echo "- Write your text here ..." >> "${text_file}"
    echo "- Then press the 'TAB' key and then 'ENTER'" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
else
    touch "${text_file}"
    echo "- Write your text here ..." >> "${text_file}"
    echo "- Then press the 'TAB' key and then 'ENTER'" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
    printf "\n" >> "${text_file}"
fi

if [[ ! -d "$converter_tool/sounds" ]]; then
    mkdir "$converter_tool/sounds"
fi

function selected_sound_option_menu(){
if [[ "$selected_sound_option" == 1 ]]; then
    if [[ -d "$termux_path" ]]; then
        pulseaudio -k 2>/dev/null
        pulseaudio -D 2>/dev/null
        $DIALOG --backtitle "$program_name - $current_tool_name" \
               --title "PLAY AUDIO" \
               --prgbox "echo play audio: $selected_audios; play $converter_tool/sounds/$selected_audios" 12 60

        pulseaudio -k 2>/dev/null
    else
        option_only_for_termux
    fi

elif [[ "$selected_sound_option" == 2 ]]; then
    select_a_directory
    if [[ -d "$chosen_directory" ]]; then
        if [[ -f "$converter_tool/sounds/$selected_audios" ]]; then
            mv "$converter_tool/sounds/$selected_audios" "$chosen_directory" 2>/dev/null
            $DIALOG --backtitle "$program_name - $current_tool_name" \
                    --colors --cr-wrap --title "INFORMATION" \
                    --msgbox "The file '\Z2\Zu$selected_audios\Zn' was moved to '\Z4\Zu\Zb$chosen_directory\Zn' successfully." 9 60
        else
            unexpected_error
        fi
    fi
elif [[ "$selected_sound_option" == 3 ]]; then
    if [[ -f "$converter_tool/sounds/$selected_audios" ]]; then
        _rename_audio=$($DIALOG --stdout --backtitle "$program_name - $current_tool_name" \
                                --title "RENAME" \
                                --ok-label "Rename" \
                                --inputbox "Rename the file:" 10 51 "$selected_audios")

        case $? in
            0)
                if [[ -n "$_rename_audio" ]]; then
                    mv "$converter_tool/sounds/$selected_audios" "$converter_tool/sounds/$_rename_audio"
                    $DIALOG --backtitle "$program_name - $current_tool_name" \
                            --title "INFORMATION" \
                            --msgbox "The file name '$selected_audios' was successfully changed to: '$_rename_audio'" 9 60
                else
                    unexpected_error
                fi
                ;;
            255)
                echo $(clear)
                echo "Program aborted." >&2
                echo "";exit 1
                ;;
        esac
    else
        unexpected_error
    fi
elif [[ "$selected_sound_option" == 4 ]]; then
    if [[ -f "$converter_tool/sounds/$selected_audios" ]]; then
        delete_file_or_directory "file" "$converter_tool/sounds/$selected_audios"
        sound_directory=$(ls "$converter_tool/sounds" |wc -l)
        if [[ "$sound_directory" == 0 ]]; then
            unexpected_error
        fi
    else
        unexpected_error
    fi
else
    unexpected_error
fi
}

function audios_created(){
while :
do
sound_directory=$(ls "$converter_tool/sounds" |wc -l)
if [[ "$sound_directory" == 0 ]]; then
    $DIALOG --backtitle "$program_name - $current_tool_name" \
            --title "INFORMATION" \
            --msgbox "No audio has been created yet!" 8 40
    break
fi
lista_audiosc=$(find "$converter_tool/sounds" -mindepth 1 -maxdepth 1 -type f -not -name '.*' -printf "%f %TY-%Tm-%Td off\n");
selected_audios=$($DIALOG --scrollbar --backtitle "$program_name - $current_tool_name" \
                --colors --ok-label "Select" --title "MP3 AUDIOS" \
                --radiolist "Press the \Z4\Zu\Zb'SPACE'\Zn key and then \Z4\Zu\Zb'ENTER'\Zn" \
                13 55 5 $lista_audiosc --output-fd 1)

_CSOUND=$?
case $_CSOUND in
    0)
        if [[ -z "$selected_audios" ]]; then
            unexpected_error
        fi
        selected_sound_option=$($DIALOG --stdout --backtitle "$program_name - $current_tool_name" \
                                    --title "MENU" --ok-label "Select" --menu "" 10 45 4 \
                                    1 "[ PLAY AUDIO   ]" \
                                    2 "[ MOVE AUDIO   ]" \
                                    3 "[ RENAME AUDIO ]" \
                                    4 "[ DELETE AUDIO ]")

        case $? in
            0)
                selected_sound_option_menu
                ;;
            255)
                echo $(clear)
                echo "Program aborted." >&2
                echo "";exit 1
                ;;
        esac
        ;;
    1)
        break
        ;;
    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
done
}

function show_transform_to_audio(){
while :
do
    $DIALOG --backtitle "$program_name - $current_tool_name" \
        --title "CONVERTER" \
        --infobox "Converting text to mp3 audio ..." 8 46; sleep 3.6

    if [[ -f "$audio_created" ]]; then
        rm ${audio_created} 2>/dev/null
        rm ${audio_file_name} 2>/dev/null
        break
    fi
    $DIALOG --backtitle "$program_name - $current_tool_name" \
        --title "CONVERTER" \
        --infobox "Please wait..." 8 41; sleep 3
done

$DIALOG --backtitle "$program_name - $current_tool_name" \
    --title "CONVERTER" \
    --msgbox "The text has been converted to audio successfully." 8 50

audios_created

}

function run_the_audio_converter(){
let _CAUDIOS_NUM_GOBLINN=$(find "$converter_tool/sounds/" -type f |wc -l);
let _CAUDIOS_NUM_GOBLIN=$(($_CAUDIOS_NUM_GOBLINN+1))
_NNAMEAUDIO_GOBLIN=$(printf "Audio_$(randdata 5)_%02d.mp3" ${_CAUDIOS_NUM_GOBLIN})
languagemenu_audio=$($DIALOG --stdout --nocancel --begin 2 2 --backtitle "$program_name - $current_tool_name" \
                            --item-help --colors --title "LANGUAGE" \
                            --radiolist "" 10 41 3 \
                            "ES" "[ SPANISH ]" ON "Press the \Z2\Zr\Zb'SPACE'\Zn key and then \Z2\Zr\Zb'ENTER'\Zn" \
                            "EN" "[ ENGLISH ]" off "Press the \Z2\Zr\Zb'SPACE'\Zn key and then \Z2\Zr\Zb'ENTER'\Zn" \
                            "FR" "[ FRENCH  ]" off "Press the \Z2\Zr\Zb'SPACE'\Zn key and then \Z2\Zr\Zb'ENTER'\Zn" \
                            --and-widget --begin 6 6 --title "MP3 FILE" \
                            --ok-label "create" --clear --inputbox "Enter a name for the file:" 10 45 "$_NNAMEAUDIO_GOBLIN")

case $? in
    0)
        languagemenu_select=$(echo "$languagemenu_audio" |awk -F' ' '{print $2}')
        if [[ -n "$languagemenu_select" ]]; then
            case "$languagemenu_select" in
                *.mp3)
                    audioname="$converter_tool/sounds/$languagemenu_select"
                    ;;
                *.wav)
                    audioname="$converter_tool/sounds/$languagemenu_select"
                    ;;
                *.m4a)
                    audioname="$converter_tool/sounds/$languagemenu_select"
                    ;;
                *.aiff)
                    audioname="$converter_tool/sounds/$languagemenu_select"
                    ;;
                *.ogg)
                    audioname="$converter_tool/sounds/$languagemenu_select"
                    ;;
                *)
                    audioname="$converter_tool/sounds/$languagemenu_select.mp3"
                    ;;
            esac
            echo "${audioname}" > "${audio_file_name}"
            languagemenu_select=$(echo "$languagemenu_audio" |awk -F' ' '{print $1}')
            if [[ $languagemenu_select == "ES" ]]; then
                python3 $converter_tool/voz_es.py & show_transform_to_audio
            elif [[ "$languagemenu_select" == "EN" ]]; then
                python3 $converter_tool/voz_en.py & show_transform_to_audio
            elif [[ "$languagemenu_select" == "FR" ]]; then
                python3 $converter_tool/voz_fr.py & show_transform_to_audio
            else
                unexpected_error
            fi
        else
            unexpected_error
        fi
        ;;
    1)
        sleep 0.2
        ;;
    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
}

TEXTC=$($DIALOG --stdout --backtitle "$program_name - $current_tool_name" --title "TEXT" \
    --extra-button --extra-label "AUDIOS" \
    --ok-label "CONVERT" --cancel-label "GO BACK" \
    --editbox "${text_file}" 13 56)

audioc=$?
case $audioc in
    0)
        echo "$TEXTC" > ${text_file} 2>/dev/null
        if [[ -n "$TEXTC" ]]; then
            run_the_audio_converter
            sleep 0.2
        else
            unexpected_error
        fi
        ;;
    1)
        sleep 0.2
        ;;
    3)
        audios_created
        ;;
    255)
        echo $(clear)
        echo "Program aborted." >&2
        echo "";exit 1
        ;;
esac
