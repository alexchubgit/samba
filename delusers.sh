#!/usr/bin/env bash

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

#достаем пользователей из /etc/passwd
grep -o '[0-9]\{11\}' /etc/passwd | uniq | while read -r file; do

    #echo "file $file" | grep 3432
    # if [ ! -z $file ]; then

    #указатель для проверки
    SIGN=0

    RESULT=$(mysql phones --user=$USER --password=$PASSWD --host=$HOST -BNe "SELECT 1 FROM persons WHERE cellular = $file OR business = $file" 2>/dev/null)

    #echo $RESULT

    if [[ "$RESULT" -eq "0" ]]; then
        echo "delete $file"   
        userdel $file  
    fi

done
