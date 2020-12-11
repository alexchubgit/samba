#!/usr/bin/env bash

# -------------------------------------------
FOLDERS=/home/user/Desktop/samba/Folders
#FILE=/home/user/Desktop/samba/Folders/
DIR_TRASH=/home/user/Desktop/samba/Trash/
# -------------------------------------------

#очищаем массив
unset array

#заполняем его строками файла deplist
array=($(cat "deplist"))

#вывод каждого пункта из массива
for i in ${array[@]}; do
        #echo item from file: $i

        for j in $FOLDERS/$i/*; do

                #echo item folder: $j

                if [ -d "$j" ]; then
                        #echo "$j is a directory"

                        #Получаем размер каждой папки
                        SIZE=$(du -s "$j" | cut -f1)

                        #Выводим размер
                        echo $SIZE

                        if (($SIZE > 4000000)); then
                                echo "Размер папки превышен"
                                mv "$j" $DIR_TRASH
                        fi
                else
                        echo "$j не является каталогом"
                        mv "$j" $DIR_TRASH
                fi
        done

done
