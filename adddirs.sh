#!/usr/bin/env bash

# -------------------------------------------
#путь к папкам
FOLDERS="$(dirname $0)/Folders"
DIR_TRASH="$(dirname $0)/Trash"
DIR_ROOT="$(dirname $0)"
# -------------------------------------------

#доступ к базе MySQL
USER="root"
#PASSWD=""
#HOST="10.80.32.116"
PASSWD=""
HOST="127.0.0.1"
# -------------------------------------------

#проверка соединения с базой данных и отмена вывода ошибок
if ! mysql --user=$USER --password=$PASSWD --host=$HOST -e "USE phones" 2>/dev/null; then
    echo "The database does not exist."
    exit 0

fi

#очищаем массив
unset deps

#заполняем его строками файла deplist
deps=($(cat "$DIR_ROOT/listdep"))

#обход каждого пункта из массива подразделений
for i in ${deps[@]}; do

    echo "$i"

    #переменную из списка подразделений переводим в название группы
    GROUP=$(echo $i | awk '{print tolower($0)}')

    mysql phones --user=$USER --password=$PASSWD --host=$HOST -B -N -s -e "SELECT name FROM persons LEFT JOIN depart USING (iddep) WHERE abbr = '$i'" 2>/dev/null | (
        while read -r line; do
            if [ ! -z "$line" ]; then

                echo "$line"

                #если файл является папкой
                if [ -d "$FOLDERS/$i/$line" ]; then
                    echo "Папка уже существует"
                else
                    echo "Папка отсутствует"
                    mkdir "$FOLDERS/$i/$line"
                fi

            fi

        done
    )

    #присваиваем группу папке и назначаем права
    chgrp -R "$GROUP" "$FOLDERS/$i/"
    chmod -R 775 "$FOLDERS/$i/"

done
