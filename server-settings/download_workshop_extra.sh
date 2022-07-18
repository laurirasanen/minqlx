#!/bin/bash
# There is a limit of 256 workshop items that can be loaded at once.
# This script downloads the workshop items from workshop_extra.txt
# The pk3s are then moved into baseq3. To allow people who are not
# subscribed to the workshop item to connect it is required to
# add the workshop id for the current map to self.game.workshop_items.
# See here https://github.com/QLRace/minqlx-plugins/blob/master/workshop.py
#
# TODO: merge pk3s into one pk3 file
qldsPath="$HOME/qlds"
steamcmdPath="$HOME/steamcmd"

workshopIDs=$(awk '{if ($1 !="#" && $1 != "") print $1}' $qldsPath/baseq3/workshop_extra.txt)
numOfIDs=$(echo "$workshopIDs" | wc -l)

i=1
for workshopID in $workshopIDs; do
    echo -e "Downloading item $workshopID from Steam... ($i/$numOfIDs)"
    $steamcmdPath/steamcmd.sh +login anonymous +workshop_download_item 282440 $workshopID +quit >/dev/null
    ((i++))
done

echo "Removing old pk3s in baseq3 and moving new pk3s into baseq3..."
find baseq3 -maxdepth 1 -type f -name "*.pk3" ! -name "bin.pk3" ! -name "pak00.pk3" ! -name "zz-*.pk3" -delete

for workshopID in $workshopIDs; do
    mv $steamcmdPath/steamapps/workshop/content/282440/$workshopID/*.pk3 $qldsPath/baseq3/
done

rm -rf $steamcmdPath/steamapps/workshop
echo "Done."
exit 0
