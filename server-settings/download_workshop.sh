#!/bin/bash
# Modified version of https://github.com/tjone270/Quake-Live/blob/master/qlds-scripts/autodownload.sh
# Original created by Thomas Jones on 03/10/15.
# thomas@tomtecsolutions.com
#
# Uses for loop to iterate through workshop IDs.
# Works for workshop.txt in this format https://gist.github.com/cstewart90/4fdd04c5d826ad6b039a
qldsPath="$HOME/qlds"
steamcmdPath="$HOME/steamcmd"

workshopIDs=$(awk '{if ($1 !="#" && $1 != "") print $1}' $qldsPath/baseq3/workshop.txt)
numOfIDs=$(echo "$workshopIDs" | wc -l)

i=1
for workshopID in $workshopIDs; do
    echo -e "Downloading item $workshopID from Steam... ($i/$numOfIDs)"
    $steamcmdPath/steamcmd.sh +login anonymous +workshop_download_item 282440 $workshopID +quit > /dev/null
    ((i++))
done;

echo "Removing old workshop data and moving new items into place..."
rm -r $qldsPath/steamapps/workshop
mv $steamcmdPath/steamapps/workshop/ $qldsPath/steamapps/workshop
echo "Done."
exit 0
