#!/usr/bin/env bash

echo "из passwd"

grep -o '[0-9]\{11\}' /etc/passwd | uniq

# for i in ${array[@]}; do
#     echo "$i"
# done
