#!/bin/bash

clear

hash ffmpeg 2>/dev/null || { echo >&2 "I require ffmpeg but it's not installed!  Aborting...."; exit 1; }

echo "This script will convert all MKV files in the current working directory to MP4, and leave existing MKV files"
echo "Current Directory: ${PWD}"
echo 
echo FILES FOUND:
for i in *.mkv; do
    echo $i
done
echo
read -p "Proceed? [Y/N]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
  then
    clear
    for i in *.mkv; do
        echo "- Converting $i... -"
        ffmpeg -i "$i" -codec copy "${i%.*}.mp4"  -v quiet -stats


        echo "- $i Complete -"
        echo
        echo
    done
    echo "Complete"
  else
    echo "Exiting..."
fi
