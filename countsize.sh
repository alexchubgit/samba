#!/usr/bin/env bash

# -------------------------------------------
#путь к папкам
FOLDERS="$(dirname $0)/Folders"
DIR_TRASH="$(dirname $0)/Trash"
DIR_ROOT="$(dirname $0)"
# -------------------------------------------

#очищаем массив
unset deps

#заполняем его строками файла deplist
deps=($(cat "$DIR_ROOT/listdep"))

#вывод каждого пункта из массива
for i in ${deps[@]}; do
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

#необходимо удалять в папку trash/папка с датой удаления