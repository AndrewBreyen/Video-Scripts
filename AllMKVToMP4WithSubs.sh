clear

echo FILES FOUND:
for i in *.mkv; do
    echo $i
done

read -p "Proceed? [Y/N]" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
  then
    clear
    for i in *.mkv; do
        echo "- Converting $i... -"
        ffmpeg-bar -i "$i" -vcodec h264_videotoolbox -acodec aac -b:v 2500k "${i%.*}_h264.mkv"
        echo "- Extracting subs for $i... -"
        ffmpeg-bar -i "$i" -map "0:m:language:eng" -map "-0:v" -map "-0:a" "${i%.*}.srt"
        # ffmpeg -i "$i" -codec copy "${i%.*}.mp4"  -v quiet -stats


        echo "- $i Complete -"
        echo
        echo
    done
    echo "Complete"
  else
    echo "Exiting..."
fi
