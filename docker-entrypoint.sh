#!/bin/bash
set -e

if [[ -z "$KAFKA_PORT" ]]; then
  export KAFKA_PORT=9092
fi

if [[ -z "$KAFKA_BROKER_ID" ]]; then
  export KAFKA_BROKER_ID=-1
fi

if [[ -z "$KAFKA_LOG_DIRS" ]]; then
  export KAFKA_LOG_DIRS="/kafka/kafka-logs-$HOSTNAME"
fi

if [[ -z "$KAFKA_LISTENERS" ]]; then
  export KAFKA_LISTENERS="PLAINTEXT://:$KAFKA_PORT"
fi

for VAR in `env`
do
  if [[ $VAR =~ ^KAFKA_ && ! $VAR =~ ^KAFKA_HOME && ! $VAR =~ ^KAFKA_VERSION ]]; then
    kafka_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$kafka_name=" $KAFKA_HOME/config/server.properties; then
        sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" $KAFKA_HOME/config/server.properties #note that no config values may contain an '@' char
    else
        echo "$kafka_name=${!env_var}" >> $KAFKA_HOME/config/server.properties
    fi
  fi
done

exec "$@"
