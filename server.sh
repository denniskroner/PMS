#!/bin/bash

if [ -e server_pipe ]; then
        rm -r server_pipe
fi

echo "Server Started"
mkdir -p "$(pwd)/Server"

mkfifo server_pipe
while true; do
        read -r clientID check_case user_name user_service user_login < server_pipe
        sleep 1
            
        arr=()
        i=0
        for val in "$user_name" "$user_service" "$user_login"; do
                if [ -n "$val" ]; then
                        arr[i]="$val"
                fi
                i+=1
        done

        case "$check_case" in
                init)
                        retn_value=$(./init.sh "${arr[@]}" &)
                        echo "$retn_value" > "$clientID.pipe"
                        ;;
                insert)
                        arr=("${arr[@]:0:2}" "" "${arr[@]:2}")
                        retn_value=$(./insert.sh "${arr[@]}" &)
                        echo "$retn_value" > "$clientID.pipe"
                        ;;
                show)
                        ./show.sh "${arr[@]}" > "$clientID.pipe" &
                        ;;
                update)
                        arr=("${arr[@]:0:2}" "f" "${arr[@]:2}")
                        retn_value=$(./insert.sh "${arr[@]}" &)
                        echo "$retn_value" > "$clientID.pipe"
                        ;;
                rm)
                        retn_value=$(./rm.sh "${arr[@]}" &)
                        echo "$retn_value" > "$clientID.pipe"
                        ;;
                ls)
                        ./ls.sh "${arr[@]}" > "$clientID.pipe" &
                        ;;
                shutdown)
                        echo "Sever closed" > $clientID_pipe
                        rm server_pipe
                        exit 0
                        ;;
                *)
                        echo "Error: bad request" > "$clientID.pipe"
                        rm server_pipe
                        exit 1
        esac
done