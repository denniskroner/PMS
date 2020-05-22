#!/bin/bash

#check if the number of arguments is correct
if [ "$#" -ne 4 ]; then
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
        #and if the file name is not already a folder
        service_dir="$user_dir/$2"
        if [ -f "$service_dir" ]; then
                #if input argument 3 is equal to f than update
                #user login and password otherwise return error
                if [ "$3" == "f" ]; then
                        echo -e "$4" > "$service_dir" 2>/dev/null
                        echo "OK: service updated"
                else
                        echo "Error: service already exists"
                        ./V.sh "$1"
                        exit 1
                fi
        else
                dir_name=$(dirname "$2")

                #if input service has subfolders and if they don"t exist
                if [ "$dir_name" != "." ] && [ ! -d "$user_dir/$dir_name" ];then
                        #create all folders and supfolders
                        mkdir -p "$user_dir/$dir_name"
                fi

                #create the service file and
                #write login and password into file
                echo -e "$4" > "$service_dir" 2>/dev/null
                echo "OK: service created"
        fi
fi
./V.sh "$1"
exit 0