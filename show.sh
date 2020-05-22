#!/bin/bash

#check if the number of arguments is correct
if [ "$#" -ne 2 ]; then
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
        #check if the service file exist already
        service_file="$user_dir/$2"
        if [ ! -f "$service_file" ]; then
                echo "Error: service does not exist"
                ./V.sh "$1"
                exit 1
        else
                srvc_file=$(cat "$service_file")
                echo "$srvc_file" 2>/dev/null
        fi
fi
./V.sh "$1"
exit 0