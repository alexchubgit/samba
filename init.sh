#!/usr/bin/env bash

# -------------------------------------------
#путь к папкам
FOLDERS="$(dirname $0)/Folders"
DIR_TRASH="$(dirname $0)/Trash"
DIR_ROOT="$(dirname $0)"
#--------------------------------------------

#очищаем массив
unset deps

#заполняем массив строками из файла
deps=($(cat "$DIR_ROOT/listdep"))

#вывод каждого пункта из массива
for i in ${deps[@]}; do

    if [ ! -z "$i" ]; then

        #проверка существования директории
        if ! [ -d "$FOLDERS/$i" ]; then
            mkdir "$FOLDERS/$i"
            echo "folder created"
        else
            echo "folder $i already exists"
        fi

        #переменную из списка подразделений переводим в название группы
        GROUP=$(echo $i | awk '{print tolower($0)}')

        if $(grep -q -E "$GROUP:" /etc/group); then

            echo "group $GROUP already exists"

            #присваиваем группу папке и назначаем права
            chgrp "$GROUP" "$FOLDERS/$i"
            chmod -R 775 "$FOLDERS/$i"

        else
            groupadd "$GROUP"
            echo "group $GROUP created"

            chgrp "$GROUP" "$FOLDERS/$i"
            chmod -R 775 "$FOLDERS/$i"
        fi

    fi

done
