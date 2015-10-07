#!/bin/bash

echo "To subscribe this: kafkacat -C -t counter -b 192.168.59.103:9092"

for i in `seq 100000`
do
    cat <<EOF
{"timestamp": "$(date +%s)", "count": ${i}}
EOF
    sleep 1s
done | kafkacat -P -t counter -b 192.168.59.103:9092

