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
        ffmpeg -i "" -codec copy "${i%.*}.mp4"  -v quiet -stats


        echo "- Deleting $i... -"
        rm "$i"

        echo "- $i Complete -"
        echo
        echo
    done
    echo "Complete"
  else
    echo "Exiting..."
fi
