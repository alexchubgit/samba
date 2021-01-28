#!/usr/bin/env bash

# -------------------------------------------
#путь к папкам
FOLDERS="$(pwd)/Folders"
DIR_TRASH="$(pwd)/Trash"

#доступ к базе MySQL
USER="root"
#PASSWD=""
#HOST="10.80.32.116"
PASSWD=""
HOST="127.0.0.1"
# -------------------------------------------

#проверка соединения с базой данных и отмена вывода ошибок
if ! mysql --user=$USER --password=$PASSWD --host=$HOST -e "USE phones" 2>/dev/null; then
    echo "A database does not exist."
    exit 0

fi

#очищаем массив
unset dep

#заполняем его строками файла deplist
dep=($(cat "listdep"))

#обход каждого пункта из массива подразделений
for i in ${dep[@]}; do

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
