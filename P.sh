#!/bin/bash

if [ -z "$1" ]; then
        echo "Error: parameter problem"
        exit 1
else
        user="init.sh"
        userlock="$1.lock.sh"

        while ! ln "$user" "$userlock" 2>/dev/null; do
                sleep 1
        done
fi
exit 0