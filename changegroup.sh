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
    #GROUP=$(echo $i | awk '{print tolower($0)}')
    #echo $GROUP

    #Пользователи с личными телефонами. Если личный пустой, то служебный
    mysql phones --user=$USER --password=$PASSWD --host=$HOST -t -N -e "SELECT IF(cellular IS NULL OR cellular = '', business, cellular), abbr FROM persons LEFT JOIN depart USING (iddep) WHERE abbr = '$i'" 2>/dev/null | (
        while read -r line; do

            if [ ! -z $(echo $line | awk -F'|' '{print $2}') ]; then

                #echo $line

                PHONE=$(echo $line | awk -F'|' '{print $2}')
                #echo $PHONE

                #переменную из списка подразделений переводим в название группы
                GROUP=$(echo $i | awk '{print tolower($0)}')
                #echo $GROUP

                SYSGROUP=$(id -gn $PHONE)
                #echo 'ID -GN' $PHONE $ID

                if [ "$GROUP" = "$SYSGROUP" ]; then
                    echo $PHONE 'OK'
                else
                    echo $PHONE 'NO'
                    echo 'GROUP' $GROUP
                    echo 'SYSGROUP' $SYSGROUP

                    #Добавить юзера в группу
                    usermod -g $GROUP $PHONE
                    usermod -G "" $PHONE

                fi

            fi

        done
    )

done

#после добавления пользователей сбрасываются права
chmod -R 775 $FOLDERS