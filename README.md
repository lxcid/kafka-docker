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

- No custom init script
- No create topics
- No discovering broker list

Some of these features may be added in the future but the goal of this project is to build a production ready Kafka docker image.

## Auto Assigned Broker ID

If you did not provides a `KAFKA_BROKER_ID` environment variable, The system will use [nextbrokerid](https://github.com/lxcid/kafka-nextbrokerid) to figure out the next broker ID to use. Warning, if you use auto assigned broker ID, scaling them concurrently is likely to cause race condition. It is recommended that you add an interval in between scaling.

## Environment Variables

| Name | Description | Default Value |
| ---: | --- | :---: |
| `SCALA_VERSION` | The Scala version | `2.12` |
| `KAFKA_VERSION` | The Kafka version | `0.10.2.1` |
| `KAFKA_HOME` | The home directory of Kafka | `/opt/kafka` |
| `KAFKA_PORT` | The port to run Kafka on | `9092` |
| `KAFKA_BROKER_ID` | The id of the broker. This must be set to a unique integer for each broker. |  |
| `KAFKA_LOG_DIRS` | A comma seperated list of directories under which to store log files | `/kafka/kafka-logs-$HOSTNAME` |
| `KAFKA_ZOOKEEPER_CONNECT` | Zookeeper connection string (see zookeeper docs for details). |  |
| `KAFKA_*` | Any environment variables that begin with `KAFKA_` (except for `KAFKA_VERSION` and `KAFKA_HOME`) will be written to `/opt/kafka/config/server.properties` accordingly.<br>e.g. `KAFKA_ZOOKEEPER_CONNECT=localhost:2181` ⤑ `zookeeper.connect=localhost:2181` |  |

## Usage

### Build

```sh
docker build --tag=lxcid/kafka .
```

### Push

```sh
docker push $DOCKER_ID_USER/kafka
```
