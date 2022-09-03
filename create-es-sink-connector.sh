#!/bin/bash
#export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081,http://ccm-l2-kafka-node2:8081,http://ccm-l2-kafka-node3:8081"
export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081"

generate_payload() {
cat <<EOF
{
  "name": "elasticsearch-sink-connector",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "connection.url": "http://ccm-l2-kafka-node1:9200",
    "topics": "ccm1-tcp-inbound-raw-data,ccm2-tcp-inbound-raw-data",
    "key.ignore": "true",
    "tasks.max": 1,
    "type.name": "_doc", 
    "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "transforms": "Cast",
    "transforms.Cast.type": "org.apache.kafka.connect.transforms.Cast\$Value",
    "transforms.Cast.spec": "string",
    "behavior.on.malformed.documents": "ignore"
  }
}
EOF
}


#echo "Payload: $(generate_payload)"

curl -X POST -H "Content-Type: application/json" --data "$(generate_payload)"  ccm-l2-kafka-node1:8083/connectors
echo -e "\n"
