#!/usr/bin/env bash

# -------------------------------------------
#путь к папкам
FOLDERS="$(pwd)/Folders"
DIR_TRASH="$(pwd)/Trash"
# -------------------------------------------

#очищаем массив
unset dep

#заполняем его строками файла deplist
dep=($(cat "listdep"))

#вывод каждого пункта из массива
for i in ${dep[@]}; do
        echo item from file: $i

        for j in $FOLDERS/$i/*; do

                echo item folder: "$j"

                if [ -d "$j" ]; then
                        #echo "$j is a directory"

                        #Получаем размер каждой папки
                        SIZE=$(du -s "$j" | cut -f1)

                        #Выводим размер
                        #echo $SIZE

                        #проверка размера папки, если > 4Гб, то в корзину
                        if (($SIZE > 4000000)); then
                                echo "Размер папки превышен "$j""
                                mv "$j" $DIR_TRASH
                        fi
                else
                        echo "$j не является каталогом"
                        mv "$j" $DIR_TRASH
                fi
        done

done
