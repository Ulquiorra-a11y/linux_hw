#!/bin/bash
target_address="steampowered.com"
max_ping_time_ms=10
max_failures=3
failures=0
while true;
do
ping_result=$(ping -c 1 "$target_address" | grep 'icmp_seq')
ping_time=$(echo "$ping_result" | awk -F'=' '{print $4}' | awk '{print $1}' | awk -F'.' '{print $1}')

if [ -n "$ping_time" ] && [ "$ping_time" -gt "$max_ping_time_ms" ]; then
	echo "Ping $target_address bigger $max_ping_time_ms ms: $ping_time ms."
fi

if [ -z "$ping_time" ]; then
	echo "Ping ERROR ."
 	((failures++))
else
 	echo "Ping $target_address successful: $ping_time ms."
 	failures=0
fi

if [ "$failures" -ge "$max_failures" ]; then
 	echo "You use all attempts."
 	failures=0
fi

sleep 1

done
