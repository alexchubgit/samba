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

#Пользователи с личными телефонами. Если личный пустой, то служебный
mysql phones --user=$USER --password=$PASSWD --host=$HOST -t -N -e "SELECT IF(cellular IS NULL OR cellular = '', business, cellular), abbr, passwd FROM persons LEFT JOIN depart USING (iddep) WHERE abbr IS NOT NULL;" | (
    while read -r line; do

        if [ ! -z $(echo $line | awk -F'|' '{print $2}') ]; then

            #echo $line

            echo $line | awk -F'|' '{print $2}'

            #попробовать логин и пароль сделать одинаковыми
            #до появления решения

            #echo $line | awk '{print $NF}'

            # const passwd = 123456;

            # //Добавить юзера
            #echo "echo idEt38 | sudo -S  useradd -G  + group + '' + $line"

            # //Добавить samba юзера
            #"echo idEt38 | (echo " + passwd + "; echo " + passwd + ") | sudo -S  smbpasswd -a " + $line

            # //Добавить юзера в группу
            #"echo idEt38 | sudo -S usermod -g " + group + " " + $line

            #Удалить группу по телефону
            #"echo idEt38 | sudo -S groupdel " + $line

        fi
    done
)
