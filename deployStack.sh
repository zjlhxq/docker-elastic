#!/bin/bash

export ELASTICSEARCH_USERNAME="elastic"
export ELASTICSEARCH_PASSWORD="changeme"
export ELASTICSEARCH_HOST="ccm-l2-kafka-node1"
export KIBANA_HOST="ccm-l2-kafka-node2"
export INITIAL_MASTER_NODES="ccm-l2-kafka-node1,ccm-l2-kafka-node2,ccm-l2-kafka-node3"
export ELASTIC_VERSION="7.17.5"
#export ELASTIC_VERSION="8.3.3"
export DOCKER_REPO="docker.nextgen.io:5000/"
export BOOTSTRAP_SERVERS="ccm-l2-kafka-node1:9092,ccm-l2-kafka-node2:9092,ccm-l2-kafka-node3:9092"
export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081,http://ccm-l2-kafka-node2:8081,http://ccm-l2-kafka-node3:8081"

docker stack deploy --compose-file docker-compose.yml --with-registry-auth elastic
