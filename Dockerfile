FROM java:openjdk-8-jre-alpine

MAINTAINER Stan Chang Khin Boon <me@lxcid.com>

ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 0.10.2.1

RUN apk --no-cache add bash wget
RUN wget \
      -q http://www-us.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
      -O /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
    mkdir -p /opt && \
    tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt && \
    ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka && \
    rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

ENV KAFKA_HOME /opt/kafka
ENV PATH ${PATH}:${KAFKA_HOME}/bin

COPY docker-entrypoint.sh /usr/local/bin
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

EXPOSE 9092

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["kafka-server-start.sh", "/opt/kafka/config/server.properties"]
