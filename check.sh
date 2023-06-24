#!/bin/bash
cat << "EOF"
     _________
    / ======= \
   / __________\
  | ___________ |
  | | -       | |
  | |         | |         IM-Hanzou
  | |_________| |___________________________
  \=____________/   Mass MySQL DB Checker   )
  / """"""""""" \                          /
 / ::::::::::::: \                     =D-'
(_________________)

EOF
read -p "Credentials List (host|user|pass): " input_file

output_file="DB_Live.txt"

if [ -f "$output_file" ]; then
    rm "$output_file"
fi

check_mysql_credential() {
    local host=$1
    local user=$2
    local password=$3
    
    if mysql --host=$host --user=$user --password=$password --connect-timeout=10 -e "SELECT 1" >/dev/null 2>&1; then
        echo "$host|$user|$password" >> "$output_file"
        echo -e "\e[1;32m$host|$user|$password > LIVE\e[0m"
    else
        echo -e "\e[1;31m$host|$user|$password > DEAD\e[0m"
    fi
}

while IFS= read -r line; do
    if [[ $line != *"|"* ]]; then
        continue
    fi

    host=$(echo "$line" | awk -F '|' '{print $1}')
    user=$(echo "$line" | awk -F '|' '{print $2}')
    password=$(echo "$line" | awk -F '|' '{print $3}')
    
    check_mysql_credential "$host" "$user" "$password" &
done < "$input_file"

wait

echo "Process done. Result saved to $output_file"
