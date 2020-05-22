#!/bin/bash

#check if the number of arguments is correct
if [ "$#" -ne 1 ]; then
        echo "Error: parameters problem"
        exit 1
fi

./P.sh "$1"
if [ "$?" -eq 0 ]; then
        #check if the user exist already in server directory
        dir_name="$(pwd)/Server/$1"
        if [ -e "$dir_name" ]; then
                echo "Error: user already exists"
                ./V.sh "$1"
                exit 1
        else
                mkdir "$(pwd)/Server/$1"
                echo "OK: user created"
        fi
fi
./V.sh "$1"
exit 0