#!/bin/bash

if [ -z "$1" ]; then
        echo "Error: parameter problem"
        exit 1
else
        rm -r "$1.lock.sh"
fi
exit 0