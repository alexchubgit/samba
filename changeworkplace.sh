#!/usr/bin/env bash

# -------------------------------------------
#путь к папкам
FOLDERS="$(pwd)/Folders"

#--------------------------------------------

for j in $FOLDERS/*/*; do
    echo $(basename -- "$j")



    #mysql select name, abbr from where name = $j
    #if abbr then mv to folders/abbr
    #
    #
done
