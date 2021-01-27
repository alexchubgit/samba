#!/usr/bin/env bash

# -------------------------------------------
#доступ к базе MySQL
USER="root"
#PASSWD="idEt38"
#HOST="10.80.32.116"
PASSWD="ju0jiL"
HOST="127.0.0.1"
# -------------------------------------------

echo "из базы данных"

> listnames

mysql phones -u$USER -p$PASSWD -h$HOST -B -N -s -e "SELECT name FROM persons" 2>/dev/null | while read -r j; do

    if [ ! -z "$j" ]; then
        echo "$j" | cut -f1 >> listnames
        echo "$j" | cut -f1
    else
        echo ""
    fi

done



