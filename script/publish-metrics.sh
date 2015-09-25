#!/bin/bash

echo "To subscribe this: kafkacat -C -t app-metrics-1 -b 192.168.59.103:9092"

while : ;
do
    date +%Y%m%d%H%M%S
    sleep 1s
done | kafkacat -P -t app-metrics-1 -b 192.168.59.103:9092

