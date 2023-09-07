clear

echo FILES FOUND:
echo $1

read -p "Proceed? [Y/N]" -n 1 -r
echo    # (optional) move to a new line

ffmpeg-bar -i $1 -vf scale=1920:1080 -preset slow -crf 18 -filter:v fps=30 "${1%.*}-converted.mp4"

# echo FILES FOUND:
# for i in *.MOV; do
#     echo $i
# done
#
# read -p "Proceed? [Y/N]" -n 1 -r
# echo    # (optional) move to a new line
# if [[ $REPLY =~ ^[Yy]$ ]]
#   then
#     clear
#     for i in *.MOV; do
#         echo "- Converting $i... -"
#         ffmpeg -i "$i" -vcodec h264_videotoolbox -acodec aac -b:v 25000k "${i%.*}-c.mp4"
#
#
#         echo "- $i Complete -"
#         echo
#         echo
#     done
#     echo "Complete"
#   else
#     echo "Exiting..."
# fi
