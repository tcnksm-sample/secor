#!/bin/bash

echo "To subscribe this: kafkacat -C -t app-log-1 -b 192.168.59.103:9092"

tail -f /var/log/system.log | kafkacat -P -t app-log-1 -b 192.168.59.103:9092
