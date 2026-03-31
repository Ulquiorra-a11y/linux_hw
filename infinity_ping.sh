#!/bin/bash

target_address="steampowered.com"
max_ping_time_ms=100
max_failures=3
failures=0

while true
do
    result=$(ping -c 1 -W 1 "$target_address")

    if [ $? -ne 0 ]; then
        echo "Ping ERROR"
        ((failures++))
    else
        time=$(echo "$result" | grep time= | awk -F'time=' '{print $2}' | awk '{print $1}')
        t=${time%.*}

        echo "Ping $target_address: $time ms"
        failures=0

        if [ "$t" -gt "$max_ping_time_ms" ]; then
            echo "WARNING: ping > $max_ping_time_ms ms"
        fi
    fi

    if [ "$failures" -ge "$max_failures" ]; then
        echo "ERROR: 3 consecutive failures"
        failures=0
    fi

    sleep 1
done


