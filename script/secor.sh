#!/bin/bash

# Change directory to read .envrc
DIR=$(cd $(dirname ${0})/.. && pwd)
cd $DIR

echo "==> Build docker image for secor"
docker build -t tcnksm/secor .

echo "==> Run secor"
docker run --rm -it \
       --link kafka:kafka \
       --env AWS_ACCESS_KEY=${AWS_ACCESS_KEY} \
       --env AWS_SECRET_KEY=${AWS_SECRET_KEY} \
       --env AWS_ENDPOINT=${AWS_ENDPOINT} \
       --env S3_BUCKET=${S3_BUCKET} \
       --env PARSER="json" \
       tcnksm/secor

