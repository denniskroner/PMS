#!/bin/bash

#check if the number of arguments is correct
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
        echo "Error: parameters problem"
        exit 1
fi

#check if the user exist already in server directory
user_dir="$(pwd)/Server/$1"
if [ ! -d "$user_dir" ]; then
        echo "Error: user does not exist"
        exit 1
fi

./P.sh "$1"
if [ "$?" -eq 0 ]; then
        present_wd="$(pwd)"
        if [ "$#" -eq 1 ]; then
                cd "$user_dir"
                cd ..
                service_folder=$(tree -A -N --noreport "$1")
                echo -e "OK:\n$service_folder"
                cd "$present_wd"
        else
                folder="$user_dir/$2"
                if [ ! -d "$folder" ]; then
                        echo "Error: folder does not exist"
                        ./V.sh "$1"
                        exit 1
                else
                        cd "$folder"
                        cd ..
                        bn_folder=$(basename "$folder")
                        service_folder=$(tree -A -N --noreport "$bn_folder")
                        echo -e "OK:\n$service_folder"
                        cd "$present_wd"
                fi
        fi
fi
./V.sh "$1"
exit 0