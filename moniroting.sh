#!/bin/bash

for((i=0;i<40;i++))
do
    mem_usage=$(free -m | awk '/^Mem:/{print $3}')
    cpu_usage=$(top -bn1 | awk '/Cpu/{print $2}')
    cpu_usage=$(echo "$cpu_usage" | sed 's/,/./g')
    echo "$i,$mem_usage,$cpu_usage" >> output.csv
    sleep 15
done
