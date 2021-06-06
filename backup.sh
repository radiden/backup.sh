#!/usr/bin/env bash
# why did i write this?

# user vars

backuppath="/your/backup/dir"
datecommand="date +%Y-%m-%dT%H:%M"

# color definitions

RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
RESET="\e[39m"

# color print functions

red () {
    echo -e "$RED$@$RESET"
}

green () {
    echo -e "$GREEN$@$RESET"
}

blue () {
    echo -e "$BLUE$@$RESET"
}

# checks of requirements

if [ ! $(which jq) ]; then
    red "jq missing! please install it."
    exit 1
fi

if [ ! -f "config.json" ]; then
    red "config.json missing!"
    exit 1
fi

if [ ! -d $backuppath ]; then
    mkdir -p $backuppath
fi

# more var definitions

IFSBAK=$IFS
folderexpr='([^!\/]+)$'
config=$(cat config.json)
conflen=$(echo $config | jq '. | length')

# main backup logic

for i in $(seq 0 $(echo "$conflen-1" | bc)); do
    curr_dir=$(echo $config | jq -r ".[$i].target")
    curr_name=$(echo $config | jq -r ".[$i].name")
    blue "backing up $curr_dir"
    cd $curr_dir/.. 2> /dev/null
    if [[ $? != 0 ]]; then
        red "no such directory!"
        continue
    fi
    [[ $curr_dir =~ $folderexpr ]]
    if [[ -z $curr_name ]]; then
        7z a "$backuppath${BASH_REMATCH[0]}_$($datecommand)" "${BASH_REMATCH}" > /dev/null 2>%1 && green "backed up ${BASH_REMATCH[0]}!" || red "backup of ${BASH_REMATCH[0]} failed."
    else
        7z a "$backuppath"$curr_name"_$($datecommand)" "${BASH_REMATCH}" > /dev/null 2>%1 && green "backed up $curr_name!" || red "backup of ${BASH_REMATCH[0]} failed."
    fi
done
