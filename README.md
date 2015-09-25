# Secor

This is sample project to try [secor](https://github.com/pinterest/secor), secor is tool for kafka log persistence.

## Build

To build image

```bash
$ docker build -t tcnksm/secor .
```

## Usage

To run `tcnksm/sector` we need to run kafka. It's easy to use [tcnksm/single-kafka](https://github.com/tcnksm/dockerfile-single-kafka). You can run it by the following command,

```bash
$ ./script/kafka.sh
```

Then, run `tcnksm/secor`,

```bash
$ ./script/secor.sh
```

*NOTE*: You need to prepare data on kafka before run secor.

## Debug

To see logs are stored on container,

```bash
$ docker exec -it secor bash
$ ls /tmp/secor_data/message_logs/backup/
```
