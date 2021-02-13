#!/usr/bin/env bash

#Проверяем папки в общих папках в цикле
#и если они не совпадают со списком пользователей, то удаляем

# -------------------------------------------
#путь к папкам
FOLDERS="$(dirname $0)/Folders"
DIR_TRASH="$(dirname $0)/Trash"
DIR_ROOT="$(dirname $0)"

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
unset deps

#заполняем его строками файла deplist
deps=($(cat "$DIR_ROOT/listdep"))

#обход каждого пункта из массива подразделений
for i in ${deps[@]}; do

    #вывод подразделения
    #echo $i

    #вывод всех файлов из папки подразделения
    for j in $FOLDERS/$i/*; do

        #если файл является папкой
        if [ -d "$j" ]; then

            #вывод имени файла
            echo $(basename -- "$j")

            #указатель для проверки
            SIGN=0

            #достаем имена пользователей в базе для названий папок
            mysql phones --user=$USER --password=$PASSWD --host=$HOST -B -N -s -e "SELECT name FROM persons LEFT JOIN depart USING (iddep)  WHERE abbr = '$i'" 2>/dev/null | (
                while read -r line; do
                    if [ ! -z "$line" ]; then
                        if [ "$(basename -- "$j")" = "$line" ]; then
                            #при совпадении указатель меняем
                            SIGN=1
                        fi
                    fi
                done

                #если указатель не равен 0, то папка есть в базе данных
                if [ "$SIGN" -eq "0" ]; then
                    echo "delete $j"
                    mv "$j" $DIR_TRASH
                fi
            )
        else
            echo "$j not a directory"
            echo "delete $j"
            mv "$j" $DIR_TRASH
        fi
    done
done