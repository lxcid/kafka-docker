# Quick Start

This setup is useful for going through the [Quick Start](https://kafka.apache.org/documentation/#quickstart) section of Kafka's documentation.

Starting from Step 3 onwards…

## Services

- 1 Zookeeper instance
- 1 Kafka instance

## Usage

### Up

```sh
docker-compose -p quickstart up -d
```

### Down

```sh
docker-compose -p quickstart down
```

### Reset

```sh
rm -rf services/kafka/volumes/kafka/kafka-logs-*/ services/zookeeper/volumes/data/version-2 services/zookeeper/volumes/data/myid services/zookeeper/volumes/datalog/version-2
```

### Scaling Kafka

```sh
docker-compose -p quickstart scale kafka=3
# or
docker-compose -p quickstart up -d --scale kafka=3
```

### Run Commands

Either run a bash…

```sh
docker-compose -p quickstart run --rm kafka /bin/bash
```

Or run seperate commands as individual containers

```sh
# Step 3: Create a topic
docker-compose -p quickstart run --rm kafka kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 1 --partitions 1 --topic test
docker-compose -p quickstart run --rm kafka kafka-topics.sh --list --zookeeper zookeeper:2181
# Step 4: Send some messages
docker-compose -p quickstart run --rm kafka kafka-console-producer.sh --broker-list kafka:9092 --topic test
# Step 5: Start a consumer
docker-compose -p quickstart run --rm kafka kafka-console-consumer.sh --bootstrap-server kafka:9092 --topic test --from-beginning
# Step 6: Setting up a multi-broker cluster
docker-compose -p quickstart scale kafka=3 # docker-compose -p quickstart up -d --scale kafka=3
docker-compose -p quickstart run --rm kafka kafka-topics.sh --create --zookeeper zookeeper:2181 --replication-factor 3 --partitions 1 --topic my-replicated-topic
docker-compose -p quickstart run --rm kafka kafka-topics.sh --describe --zookeeper zookeeper:2181 --topic my-replicated-topic
docker-compose -p quickstart run --rm kafka kafka-topics.sh --describe --zookeeper zookeeper:2181 --topic test
docker-compose -p quickstart run --rm kafka kafka-console-producer.sh --broker-list kafka:9092 --topic my-replicated-topic
docker-compose -p quickstart run --rm kafka kafka-console-consumer.sh --bootstrap-server kafka:9092 --from-beginning --topic my-replicated-topic
docker kill -s SIGKILL quickstart_kafka_2
docker-compose -p quickstart run --rm kafka kafka-topics.sh --describe --zookeeper zookeeper:2181 --topic my-replicated-topic
docker restart quickstart_kafka_2
# Step 7 & Step 8 are currently not fully supported but you shouldn't have any issues if you know how to tweaks the configuration…
```
