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

> listusers

mysql phones -u$USER -p$PASSWD -h$HOST -B -N -s -e "SELECT cellular,  IF(cellular IS NULL OR cellular = ' ', business, cellular), IF(business IS NULL OR business = ' ', '99999999999', cellular) FROM persons" | while read -r j; do

    if [ ! -z "$j" ]; then
        echo "$j" | cut -f1 >> listusers
        echo "$j" | cut -f1
    else
        echo ""
    fi

done
