#!/bin/bash
# HM-ImageG
# Coded by Z3R07-RED

program_name="$1"
tmp_directory="tmp"
IMAGEOK="0"

# RANDOM [DATA]
# USE:
#     Example:
#             randdata 10
function randdata(){
        MATRIX="abcdefghijklmnopqrstuvwxyzABCDEFGHIJLKMNOPQRSTUVWXYZ-0123456789"
        Z3R07=""
        n=1
        i=1
        [ -z "$1" ] && length=8 || length=$1
        [ -z "$2" ] && num=1 || num=$2
        while [ ${i} -le $num ]; do
                while [ ${n} -le $length ]; do
                        Z3R07="$Z3R07${MATRIX:$(($RANDOM%${#MATRIX})):1}"
                        n=$(($n + 1))
                done
                echo $Z3R07
                n=1
                Z3R07=""
                i=$(($i + 1))
        done
}

# NEXT TEXT IMAGE
function new_text_image(){
TEXTINIMAGEN=$(zenity --forms \
                    --title="$program_name" \
                    --height=200 \
                    --width=400 \
                    --text="Write the text you want to hide" \
                    --add-entry="Enter your text:")

if [ $? -eq 0 ]; then
    if [[ -n "$TEXTINIMAGEN" ]]; then
        if [[ ! -s "$tmp_directory/bgr_color.tmp" ]]; then
            echo -e "71\n212\n136" > "$tmp_directory/bgr_color.tmp" 2>/dev/null
        fi

        if [[ -d "$tmp_directory" ]]; then
            echo -e "$TEXTINIMAGEN" > "$tmp_directory/texto_not_base64.txt" 2>/dev/null
            base64 "$tmp_directory/texto_not_base64.txt" > "$tmp_directory/texto_base64.tmp" 2>/dev/null
            rm -rf "$tmp_directory/texto_not_base64.txt" 2>/dev/null
        fi

        IIMAGENTEXT=$(zenity --file-selection \
            --title="$program_name" \
            --height=200 \
            --width=100 \
            --text="Select a file:")

        if [ $? -eq 0 ]; then
            if [[ -f "$IIMAGENTEXT" ]]; then
                BaseNameImge=$(basename "$IIMAGENTEXT" 2>/dev/null)

                case "$BaseNameImge" in
                     *.jpg|*.jpeg)
                         IMAGEOK="1"
                         ;;
                     *.png|*.webp)
                         IMAGEOK="1"
                         ;;
                     *.svg|*.psd)
                         IMAGEOK="1"
                         ;;
                     *)
                         IMAGEOK="0"
                         ;;
                 esac
                 if [[ "$IMAGEOK" == 1 ]]; then
                     cp "$IIMAGENTEXT" "$tmp_directory/goblin_07.jpg" 2>/dev/null
                     (
                     sleep 1
                     echo "10"
                     echo "# Creating new image ..."
                     echo "20"
                     python3 "$tmp_directory/text_image.py"
                     echo "50"
                     echo "# Search the archives ..."; sleep 1
                     echo "80"
                     sleep 1
                     if [[ -f "$tmp_directory/goblin_07.jpg" ]]; then
                         echo "# Very good files found!"
                     else
                         echo "# Files could not be created!"
                     fi
                     echo "100"
                     ) | zenity --progress \
                         --title="$program_name" \
                         --width=250 \
                         --text="Starting the process" \
                         --percentage=0

                     if [ "$?" = -1 ] ; then
                         zenity --error \
                             --title="$program_name - Error" \
                             --width=250 \
                             --text="A new image could not be created."
                     fi

                     if [[ -f "$tmp_directory/goblin.jpg" ]]; then
                         echo -e "\nGoblin:$(cat $tmp_directory/texto_base64.tmp)\n" >> "$tmp_directory/goblin.jpg" 2>/dev/null
                         echo -e "fin" >> "$tmp_directory/goblin.jpg" 2>/dev/null
                         rm -rf "$tmp_directory/goblin_07.jpg" 2>/dev/null
                         rm -rf "$tmp_directory/texto_base64.tmp" 2>/dev/null
                         NEWIMGENG7=$(echo "$IIMAGENTEXT" | awk -F"$BaseNameImge" '{print $1}' 2>/dev/null)
                         mv "$tmp_directory/goblin.jpg" "${NEWIMGENG7}goblin_$(randdata 5).jpg" 2>/dev/null
                         echo -e " ----------------------"
                         echo -e "| Very good new image. |"
                         echo -e " ----------------------"
                         zenity --title="$program_name" \
                             --width=250 \
                             --info --text="The image was created successfully."
                     else
                         rm -rf "$tmp_directory/texto_base64.tmp" 2>/dev/null
                         zenity --error \
                             --title="$program_name - Error" \
                             --width=250 \
                             --text="A new image could not be created."
                     fi
                 else
                     rm -rf "$tmp_directory/texto_base64.tmp" 2>/dev/null
                     zenity --error \
                         --title="$program_name - Error" \
                         --width=250 \
                         --text="The selected file is not an image or is not supported."
                 fi
            fi
        fi
    fi
fi
}

# READ IMAGE
function show_hidden_text_from_image(){
READTEXTIMAGE=$(zenity --file-selection \
            --title="$program_name" \
            --height=200 \
            --width=100 \
            --text="Select a file:")

if [ $? -eq 0 ]; then
    if [[ -f "$READTEXTIMAGE" ]]; then
        BaseNameImge=$(basename "$READTEXTIMAGE" 2>/dev/null)

        case "$BaseNameImge" in
            *.jpg|*.jpeg)
                IMAGEOK="1"
                ;;
            *.png|*.webp)
                IMAGEOK="1"
                ;;
            *.svg|*.psd)
                IMAGEOK="1"
                ;;
            *)
                IMAGEOK="0"
                ;;
        esac
        if [[ "$IMAGEOK" == 1 ]]; then
            sleep 0.4
            echo "[>] Searching for text ..."
            sleep 1
            echo "[>] Please wait ..."
            sleep 0.6
            echo "-------------------"
            echo "FILE: $BaseNameImge"
            echo "-------------------"
            let NumLineImage=$(cat "$READTEXTIMAGE" | wc -l 2>/dev/null)
            let NumLineImage2="$NumLineImage"
            let NumLineLimite="1"

            # Set a limit of lines to read
            # if [[ "500" -le "$NumLineImage2" ]]; then
            #    let NumLineLimite=$(($NumLineImage2 - 300))
            # elif [[ "400" -le "$NumLineImage2" ]]; then
            #    let NumLineLimite=$(($NumLineImage2 - 200))
            # elif [[ "200" -le "$NumLineImage2" ]]; then
            #    let NumLineLimite=$(($NumLineImage2 - 100))
            # elif [[ "100" -le "$NumLineImage2" ]]; then
            #     let NumLineLimite=$(($NumLineImage2 - 50))
            # else
            #    let NumLineLimite=$(($NumLineImage2 - 5))
            # fi

            while true;
            do
                sleep 0.4
                BuscarTextIG=$(awk "NR==$NumLineImage" "$READTEXTIMAGE" 2>/dev/null)
                echo "Line $NumLineImage - $BuscarTextIG"
                HMImageG=$(echo "$BuscarTextIG" | grep "Goblin" 2>/dev/null)
                if [[ -n "$HMImageG" ]]; then
                    HMIGMostrar=$(echo "$HMImageG" | awk -F':' '{print $2}')
                    echo "$HMIGMostrar" > "$tmp_directory/HM_ImageG.txt" 2>/dev/null
                    if [[ "$NumLineImage" != "$NumLineImage2" ]]; then
                        while true;
                        do
                            let NumLineImage=$(($NumLineImage + 1))
                            BuscarTextIG=$(awk "NR==$NumLineImage" "$READTEXTIMAGE" 2>/dev/null)

                            if [[ "$BuscarTextIG" != "fin" ]]; then
                                echo "$BuscarTextIG" >> "$tmp_directory/HM_ImageG.txt" 2>/dev/null
                            else
                                break
                            fi
                        done
                    fi
                    break
                else
                    if [[ "$NumLineImage" != "$NumLineLimite" ]]; then
                        let NumLineImage=$(($NumLineImage - 1))

                        if [[ "$NumLineImage" == "$NumLineLimite" ]]; then
                            break
                        fi
                    else
                        break
                    fi
                fi
            done
            if [[ -n "$HMImageG" ]]; then

                base64 -d "$tmp_directory/HM_ImageG.txt" > "$tmp_directory/HM_ImageG.tmp" 2>/dev/null
                rm -rf "$tmp_directory/HM_ImageG.txt" 2/dev/null
                echo "[READ]: $READTEXTIMAGE"
                zenity --title="$program_name - Secret text" \
                      --text-info --filename="$tmp_directory/HM_ImageG.tmp"

                if [ $? -eq 0 ]; then
                    rm -rf "$tmp_directory/HM_ImageG.tmp" 2/dev/null
                    echo "exit 0"
                    exit 0
                else
                    rm -rf "$tmp_directory/HM_ImageG.tmp" 2/dev/null
                fi
            else
                zenity --title="$program_name" \
                    --width=250 \
                    --info --text="No text found in the image."
            fi
        else
            zenity --error \
                --title="$program_name - Error" \
                --width=250 \
                --text="The selected file is not an image or is not supported."
        fi
    fi
fi
}

# COLOR SELECTION
function new_color_selection(){
COLORSELECTION=`zenity --title="$program_name" --color-selection --show-palette`

if [[ $? -eq 0 ]]; then
    if [[ -n "$COLORSELECTION" ]]; then
        COLOR_BGR01=$(echo "$COLORSELECTION" | tr "(" " " | awk '{print $2}' | tr ")" " " | tr "," " " | awk '{print $3 "," $2 "," $1}' 2>/dev/null)
        COLOR_BGR=$(echo "$COLORSELECTION" | tr "(" " " | awk '{print $2}' | tr ")" " " | tr "," " " | awk '{print $3 "\n" $2 "\n" $1}' 2>/dev/null)

        if [[ -d "$tmp_directory" ]]; then
            echo -e "$COLOR_BGR" > "$tmp_directory/bgr_color.tmp" 2>/dev/null
            echo "Color-Selection : bgr($COLOR_BGR01)"
        else
            echo "Error: no tmp/ directory"
            exit 1
        fi

        zenity --title="$program_name" \
            --width=250 \
            --info --text="Color-Selection : $COLORSELECTION\n\nColor-Selection : bgr($COLOR_BGR01)"
    fi
fi
}

echo -e "Tool found ..."

while true;
do
MENUOTTER=$(zenity --list \
    --title="$program_name" \
    --height=250 \
    --width=400 \
    --column="Tools" --column="Details" \
    "Hide secret text" "Eyepiece in an image" \
    "Show secret text" "Show secret text from an image" \
    "Choose a color" "Find a new color")

if [[ $? -eq 0 ]]; then
    if [[ "$MENUOTTER" == "Hide secret text" ]]; then
        new_text_image
    elif [[ "$MENUOTTER" == "Show secret text" ]]; then
        show_hidden_text_from_image
    elif [[ "$MENUOTTER" == "Choose a color" ]]; then
        new_color_selection
    else
        echo "exit 1"
        break
    fi
else
    echo "exit 0"
    break
fi
done

# Club Secreto 07
