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
        if [ "$#" -eq 1 ]; then
                service_folder=$(tree -A -N --noreport "$user_dir")
                echo -e "OK:\n$service_folder"
        else
                folder="$user_dir/$2"
                if [ ! -d "$folder" ]; then
                        echo "Error: folder does not exist"
                        ./V.sh "$1"
                        exit 1
                else
                        service_folder=$(tree -A -N --noreport "$folder")
                        echo -e "OK:\n$service_folder"
                fi
        fi
fi
./V.sh "$1"
exit 0