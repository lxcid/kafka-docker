# Kafka's Docker
Yet another [Kafka](http://kafka.apache.org)'s [Docker](https://www.docker.com) repository

## Introduction

This is heavily based on [wurstmeister/kafka-docker](https://github.com/wurstmeister/kafka-docker) implementation but with opinionated changes that matter to me.

- Based on [the official Java alpine image](https://hub.docker.com/_/java/).
- Use `--no-cache` option when adding packages.
- Install minimal packages.
- Avoid external executable scripts in Dockerfile whenever possible.
- Use [entrypoint](https://docs.docker.com/engine/reference/builder/#entrypoint):
  - Ensure that `kafka-server-start.sh` are running as `PID 1`.
  - When running the container with custom commands, it ensure that all the environment variables and configurations are setup accordingly.

This also means that I have removed several features:

- No custom scripts

## Environment Variables

| Name | Description | Default Value |
| ---: | --- | :---: |
| `SCALA_VERSION` | The Scala version | 2.12 |
| `KAFKA_VERSION` | The Kafka version | 0.10.2.1 |
| `KAFKA_HOME` | The home directory of Kafka | /opt/kafka |
| `KAFKA_PORT` | The port to run Kafka on | 9092 |
| `KAFKA_*` | Any environment variables that begin with `KAFKA_` will be written to `/opt/kafka/config/server.properties` accordingly, except for `KAFKA_VERSION` and `KAFKA_HOME`.<br>e.g. `KAFKA_ZOOKEEPER_CONNECT=localhost:2181` ⤑ `zookeeper.connect=localhost:2181` |  |

## Usage

### Build

```sh
docker build --tag=lxcid/kafka .
```
