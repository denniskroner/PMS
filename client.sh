#!/bin/bash

if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
        echo "Error: parameter problem"
        exit 1
fi

if [ -z "$1" ]; then
        echo "Error: parameter problem"
        exit 1
fi

mkfifo "$1.pipe"

case "$2" in
        init)
                if [ -e server_pipe ]; then
                        if [ -n "$1" ] & [ -n "$3" ] ; then
                                echo "$@" > server_pipe
                                read input < "$1.pipe"
                                echo "$input"
                        else
                                echo "Error: parameter problems"
                        fi
                fi
                ;;
        insert)
                if [ -e server_pipe ]; then
                        if [ -n "$1" ] && [ -n "$3" ] && [ -n "$4" ]; then
                                echo "Please write login:"
                                read userLogin
                                echo "Please write password"
                                read userPassword

                                encryptLogin="$3""$4"
                                encryptPW="$4""$3"

                                userLogin=$(./encrypt.sh "$encryptLogin" "$userLogin")
                                userPassword=$(./encrypt.sh "$encryptPW" "$userPassword")
                                loginPw="$userLogin\\n$userPassword"
                                echo "$@" "$loginPw" > server_pipe
                                read input < "$1.pipe"
                                echo "$input"
                        else
                                echo "Error: parameter problem"
                        fi
                fi
                ;;
        show)
                if [ -e server_pipe ]; then
                        if [ -n "$1" ] && [ -n "$3" ] && [ -n "$4" ]; then
                                echo "$@" > server_pipe
                                OUT=$(mktemp)
                                cat "$1.pipe" > $OUT
                                if [ "$(head -n 1 $OUT)" != "Error: service does not exist" ]; then
                                        decryptLogin="$3""$4"
                                        decryptPW="$4""$3"

                                        userLogin=$(./decrypt.sh "$decryptLogin" "$(head -n 1 $OUT)")
                                        userPassword=$(./decrypt.sh "$decryptPW" "$(tail -n 1 $OUT)")
                                        echo -e "$3's login for $4 is: $userLogin\n$3's password for $4 is: $userPassword"
                                else
                                        echo "Error: service does not exist"
                                fi
                                rm -r $OUT
                        else
                                echo "Error: parameter problem"
                        fi
                fi
                ;;
        edit)
                if [ -e server_pipe ]; then
                        if [ -n "$1" ] && [ -n "$3" ] && [ -n "$4" ]; then
                                echo "$1" "show" "$3" "$4" > server_pipe
                                OUT=$(mktemp)
                                cat "$1.pipe" > $OUT

                                if [ "$(head -n 1 $OUT)" != "Error: service does not exist" ]; then
                                        decryptLogin="$3""$4"
                                        decryptPW="$4""$3"

                                        userLogin=$(./decrypt.sh "$decryptLogin" "$(head -n 1 $OUT)")
                                        userPassword=$(./decrypt.sh "$decryptPW" "$(tail -n 1 $OUT)")
                                        echo -e "$userLogin\n$userPassword" > $OUT
                                        nano $OUT
                                        encryptLogin="$3""$4"
                                        encryptPW="$4""$3"

                                        userLogin=$(./encrypt.sh "$encryptLogin" "$(head -n 1 $OUT)")
                                        userPassword=$(./encrypt.sh "$encryptPW" "$(tail -n 1 $OUT)")
                                        loginPw="$userLogin\n$userPassword"

                                        #loginPw="$(head -n 1 $OUT)\\n$(tail -n 1 $OUT)"
                                        echo "$1" "update" "$3" "$4" "$loginPw" > server_pipe
                                        read input < "$1.pipe"
                                        echo "$input"
                                else
                                        echo "Error: service does not exist"
                                fi
                                rm -r $OUT
                        else
                                echo "Error: parameter problem"
                        fi
                fi
                ;;
        rm)
                if [ -e server_pipe ]; then
                        if [ -n "$1" ] && [ -n "$3" ] && [ -n "$4" ]; then
                                echo "$@" > server_pipe
                                read input < "$1.pipe"
                                echo "$input"
                        else
                                echo "Error: parameter problem"
                        fi
                fi
                ;;

        ls)
                if [ -e server_pipe ]; then
                        if [ -n "$1" ] && [ -n "$3" ]; then
                                echo "$@" > server_pipe
                                cat $1.pipe
                        else
                                echo "Error: parameter problem"
                        fi
                fi
                ;;
        shutdown)
                if [ -e server_pipe ]; then
                        echo "$@" > server_pipe
                        read input < "$1.pipe"
                        echo "$input"
                fi
                ;;
        *)
                echo "Error: bad request"
                rm "$1.pipe"
                exit 1
esac
rm "$1.pipe"

exit 0