#!/usr/bin/env bash

# -------------------------------------------

#доступ к базе MySQL
USER="root"
#PASSWD=""
#HOST="10.80.32.116"
PASSWD=""
HOST="127.0.0.1"

PASSWDSMB="123456"
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

    #Пользователи с личными телефонами. Если личный пустой, то служебный
    mysql phones --user=$USER --password=$PASSWD --host=$HOST -t -N -e "SELECT IF(cellular IS NULL OR cellular = '', business, cellular), abbr, passwd FROM persons LEFT JOIN depart USING (iddep) WHERE abbr = '$i'" 2>/dev/null | (
        while read -r line; do

            if [ ! -z $(echo $line | awk -F'|' '{print $2}') ]; then

                #echo $line

                PHONE=$(echo $line | awk -F'|' '{print $2}')
                #echo $PHONE

                #переменную из списка подразделений переводим в название группы
                GROUP=$(echo $i | awk '{print tolower($0)}')
                #echo $GROUP

                #echo $line | awk '{print $NF}'

                #Добавить юзера
                #echo idEt38 | sudo -S useradd -G $GROUP $PHONE
                useradd $PHONE -g $GROUP 
                adduser $PHONE $GROUP

                #Добавить samba юзера
                # echo idEt38 | (
                #     echo $PASSWDSMB
                #     echo $PASSWDSMB
                # ) | sudo -S smbpasswd -a $PHONE

                (
                    echo $PASSWDSMB
                    echo $PASSWDSMB
                ) | smbpasswd -a $PHONE

                #Добавить юзера в группу
                #echo idEt38 | sudo -S usermod -g $GROUP $PHONE

                #Удалить группу по телефону
                #echo idEt38 | sudo -S groupdel $PHONE

            fi
        done
    )

done
