#!/bin/bash

docker run --rm -it \
  --name kafka \
  --publish 9092:9092 \
  --publish 2181:2181 \
  --env ADVERTISED_HOST=192.168.59.103 \
  --env ADVERTISED_PORT=9092 \
  --env NUM_PARTITIONS=2 \
  tcnksm/single-kafka
