#!/bin/bash

# Change directory to read .envrc
DIR=$(cd $(dirname ${0})/.. && pwd)
cd $DIR

docker run --rm -it \
       --link kafka:kafka \
       --env AWS_ACCESS_KEY=${AWS_ACCESS_KEY} \
       --env AWS_SECRET_KEY=${AWS_SECRET_KEY} \
       --env AWS_ENDPOINT=${AWS_ENDPOINT} \
       --env S3_BUCKET=${S3_BUCKET} \
       tcnksm/secor

