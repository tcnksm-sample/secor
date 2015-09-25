#!/bin/sh
set -eu

# Check must set env vars
if [ -z "${AWS_ACCESS_KEY}" ]; then
    echo "Set AWS_ACCESS_KEY via env var"
    exit 1
fi 

if [ -z "${AWS_SECRET_KEY}" ]; then
    echo "Set AWS_SECRET_KEY via env var"
    exit 1
fi

if [ -z "${S3_BUCKET}" ]; then
    echo "Set S3_BUCKET via env var"
    exit 1
fi

BROKER_PORT=${BROKER_PORT:-9092}
SEED_BROKER_HOST=${KAFKA_PORT_9092_TCP_ADDR:-${BROKER_HOST}}
SEED_BROKER_PORT=${KAFKA_PORT_9092_TCP_PORT:-${BROKER_PORT}}
if [ -z "${SEED_BROKER_HOST}" ]; then
    echo "Set SEED_BROKER_HOST via env var or link to kafka contianer"
    exit 1
fi

ZK_PORT=${ZK_PORT:-2181}
ZK_PORT=${KAFKA_PORT_2181_TCP_PORT:-${ZK_PORT}}
ZK_HOST=${KAFKA_PORT_2181_TCP_ADDR:-${ZK_HOST}}
if [ -z "${ZK_HOST}" ]; then
    echo "Set ZK_HOST via env var or link to kafka container"
    exit 1
fi
ZK_QUORUM=${ZK_HOST}:${ZK_PORT}

# secor.common.properties
# Regular expression matching names of consumed topics.
TOPIC_FILTER=${TOPIC_FILTER:-.*}

# Zookeeper path at which kafka is registered. In Zookeeper parlance, this is referred
# to as the chroot.
ZK_PATH=${ZK_PATH:-/}

# secor.prod.backup.properties
# Name of the Kafka consumer group.
SECOR_GROUP=${SECOR_GROUP:-secor_backup}

# S3 path where sequence files are stored.
S3_PATH=${S3_PATH:-raw_logs/secor_backup}

# Local path where sequence files are stored before they are uploaded to s3.
LOCAL_PATH=${LOCAL_PATH:-/tmp/secor_data/message_logs/backup}

# Parser class that extracts s3 partitions from consumed messages.
MESSAGE_PARSER_CLASS=${MESSAGE_PARSER_CLASS:-com.pinterest.secor.parser.OffsetMessageParser}

# The secor file reader/writer used to read/write the data, by default we write sequence files
# secor.file.reader.writer.factory=com.pinterest.secor.io.impl.DelimitedTextFileReaderWriterFactory

# Name of field that contains timestamp for JSON, MessagePack, or Thrift message parser
TS_NAME=${TS_NAME:-timestamp}

# To enable compression, set this to a valid compression codec implementing
# org.apache.hadoop.io.compress.CompressionCodec interface, such as
# 'org.apache.hadoop.io.compress.GzipCodec'.
# -Dsecor.compression.codec=${COMPRESSION_CODEC} \

# Upload policies
MAX_FILE_SIZE_BYTE=100000
MAX_FILE_AGE_SEC=60

java -ea \
     -Daws.access.key=${AWS_ACCESS_KEY} \
     -Daws.secret.key=${AWS_SECRET_KEY} \
     -Daws.endpoint=${AWS_ENDPOINT} \
     -Dsecor.s3.bucket=${S3_BUCKET} \
     -Dsecor.s3.path=${S3_PATH} \
     -Dzookeeper.quorum=${ZK_QUORUM} \
     -Dkafka.zookeeper.path=${ZK_PATH} \
     -Dkafka.seed.broker.host=${SEED_BROKER_HOST} \
     -Dkafka.seed.broker.port=${SEED_BROKER_PORT} \
     -Dsecor.kafka.topic_filter=${TOPIC_FILTER} \
     -Dsecor.kafka.group=${SECOR_GROUP} \
     -Dsecor.consumer.threads=1 \
     -Dsecor.local.path=${LOCAL_PATH} \
     -Dsecor.message.parser.class=${MESSAGE_PARSER_CLASS} \
     -Dmessage.timestamp.name=${TS_NAME} \
     -Dsecor.max.file.size.bytes=${MAX_FILE_SIZE_BYTE} \
     -Dsecor.max.file.age.seconds=${MAX_FILE_AGE_SEC} \
     -Dsecor.upload.manager.class=com.pinterest.secor.uploader.S3UploadManager \
     -Dsecor.file.reader.writer.factory=com.pinterest.secor.io.impl.DelimitedTextFileReaderWriterFactory \
     -Dlog4j.configuration=log4j.dev.properties \
     -Dconfig=secor.prod.backup.properties \
     -cp secor-0.2-SNAPSHOT.jar:lib/* \
     com.pinterest.secor.main.ConsumerMain
