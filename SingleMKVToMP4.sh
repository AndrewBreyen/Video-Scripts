#!/bin/bash
# Takes one command line input, the file to be converted to .mp4

clear

hash ffmpeg 2>/dev/null || { echo >&2 "I require ffmpeg but it's not installed!  Aborting...."; exit 1; }

if [ $# != 1 ]
then
    echo "ERROR: Must supply a .mkv file as a command line argument"
    echo "Usage: $0 video.mkv"
    echo "Exiting..."
    echo
    exit
fi

if [ "${1: -4}" != ".mkv" ]
then
    echo "ERROR: File supplied must be a .mkv file"
    echo "Exiting..."
    echo
    exit
fi


echo "This script will the MKV file supplied as a command line argument to MP4."
echo "File to convert: $1"
echo 

echo
read -p "Proceed? (Will *DELETE* all converted MKV files) [Y/N]" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
  then
    clear
    ffmpeg -i $1 -codec copy $1.mp4
    echo "Complete!"
  else
    echo "Exiting..."
fi



