#!/bin/bash
# TubeVide07
# Coded by Z3R07-RED on Dec 23 2020

DIALOG=${DIALOG=dialog}
current_tool_name="TubeVide07"

function visualizar_descarga_tubevideo(){
let COUNTER_TUBEVIDEO=0
let RANDOM_PROGRESS_TUBEVIDEO=$RANDOM%10
let COUNTER_DOWNLOAD_PROGRES_TUBEVIDEO=1
let DOWNLOAD_PROGRESS_TUBEVIDEO=0
python "$TUBEVIDEO" &
(while [ "$COUNTER_TUBEVIDEO" -le "100" ]
do
cat <<EOF
XXX
$DOWNLOAD_PROGRESS_TUBEVIDEO
\Zr\Z0$program_name:\Zn Downloading the video or audio ...
PROGRESS ($DOWNLOAD_PROGRESS_TUBEVIDEO):
XXX
EOF
if [[ ! -f "$youtube_file_tmp" ]]; then
    if [[ "$COUNTER_DOWNLOAD_PROGRES_TUBEVIDEO" -lt "100" ]]; then
        let DOWNLOAD_PROGRESS_TUBEVIDEO=$COUNTER_DOWNLOAD_PROGRES_TUBEVIDEO
        let COUNTER_DOWNLOAD_PROGRES_TUBEVIDEO=$(($COUNTER_DOWNLOAD_PROGRES_TUBEVIDEO+$RANDOM_PROGRESS_TUBEVIDEO))
        let RANDOM_PROGRESS_TUBEVIDEO=$RANDOM%10
    fi
else
    if [[ "$COUNTER_TUBEVIDEO" != "100" ]]; then
        let DOWNLOAD_PROGRESS_TUBEVIDEO=100
        let COUNTER_TUBEVIDEO=100
    else
        let COUNTER_TUBEVIDEO=$(($COUNTER_TUBEVIDEO+$RANDOM_PROGRESS_TUBEVIDEO))
    fi
fi
sleep 1
done) | $DIALOG --colors --backtitle "$program_name - $current_tool_name" \
    --title "DOWNLOADING" \
    --gauge "" 7 70

if [[ -f "$youtube_file_tmp" ]]; then
    rm -rf "$youtube_file_tmp" 2>/dev/null
    $DIALOG --backtitle "$program_name - $current_tool_name" \
        --clear --title "DOWNLOADED" \
        --msgbox "The mp4 file downloaded successfully.\n\n\
$chosen_directory/" 10 50
else
    unexpected_error
fi
}

$DIALOG --backtitle "$program_name - $current_tool_name" \
    --clear --colors --title "[\Z1Y0UTUB3-07\Zn]" \
    --inputbox "URL:" 10 60 2>${url_youtube_file}

case $? in
    0)
        if [[ -s "$url_youtube_file" ]]; then
            video_audio_des=$($DIALOG --stdout --backtitle "$program_name - $current_tool_name" \
                                --title "DOWNLOAD" \
                                --menu "" 10 41 2 \
                                "VIDEO" "[ MP4 720P ]" \
                                "AUDIO" "[ MP4 140K ]")

            case $? in
                0)
                    select_a_directory
                    if [[ -d "$chosen_directory" ]]; then
                        chosen_directory="$chosen_directory/$current_tool_name"
                        printf "$chosen_directory" > $DirectoryTubeVide07File
                        sleep 0.2
                        if [[ "$video_audio_des" == "VIDEO" ]]; then
                            TUBEVIDEO="$TubeVide07_tool/TubeVide07.py"

                        elif [[ "$video_audio_des" == "AUDIO" ]]; then
                            TUBEVIDEO="$TubeVide07_tool/TubeAudi07.py"

                        fi
                        visualizar_descarga_tubevideo
                    fi
                    ;;
                1)
                    sleep 0.1
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
