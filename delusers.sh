#!/usr/bin/env bash

# -------------------------------------------

#доступ к базе MySQL
USER="root"
#PASSWD="idEt38"
#HOST="10.80.32.116"
PASSWD="ju0jiL"
HOST="127.0.0.1"
# -------------------------------------------

#проверка соединения с базой данных и отмена вывода ошибок
if ! mysql --user=$USER --password=$PASSWD --host=$HOST -e "USE phones" 2>/dev/null; then
    echo "A database does not exist."
    exit 0

fi

SIGN=0

#Пользователи с личными телефонами. Если личный пустой, то служебный
mysql phones --user=$USER --password=$PASSWD --host=$HOST -B -N -s -e "SELECT IF(cellular IS NULL OR cellular = '', business, cellular) FROM persons;" 2>/dev/null | (
    while read -r mysql; do
        if [ ! -z "$mysql" ]; then

            echo $mysql

            #достаем пользователей из /etc/passwd
            grep -o '[0-9]\{11\}' /etc/passwd | uniq | while read -r passwd; do

                #echo "$passwd"

                if [ "$mysql" = "$passwd" ]; then
                    #при совпадении указатель меняем
                    SIGN=1
                fi

                #если указатель не равен 0, то пользователь есть в базе данных
                if [ "$SIGN" -eq "0" ]; then
                    echo "userdel $passwd"

                fi

            done

        fi

    done

)
