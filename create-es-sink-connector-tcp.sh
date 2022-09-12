#!/bin/bash
#export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081,http://ccm-l2-kafka-node2:8081,http://ccm-l2-kafka-node3:8081"
export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081"

generate_payload() {
cat <<EOF
{
  "name": "es-sink-connector-raw-E",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "connection.url": "http://ccm-l2-kafka-node1:9200",
    "topics": "ccm1-tcp-inbound-raw-data,ccm2-tcp-inbound-raw-data,ccm1-tcp-outbound-raw-data,ccm2-tcp-outbound-raw-data",
    "key.ignore": "true",
    "tasks.max": 1,
    "consumer.auto.offset.reset": "earliest",
    "flush.synchronously": "true",
    "type.name": "_doc", 
    "value.converter": "org.apache.kafka.connect.storage.StringConverter",
    "transforms": "MakeMap,InsertSource,InsertTimestamp,ConvertTimestamp",
    "transforms.MakeMap.type": "org.apache.kafka.connect.transforms.HoistField\$Value",
    "transforms.MakeMap.field": "message",
    "transforms.InsertSource.type": "org.apache.kafka.connect.transforms.InsertField\$Value",
    "transforms.InsertSource.static.field": "data_source",
    "transforms.InsertSource.static.value": "tcp",
    "transforms.InsertTimestamp.type": "org.apache.kafka.connect.transforms.InsertField\$Value",
    "transforms.InsertTimestamp.timestamp.field": "@timestamp",
    "transforms.ConvertTimestamp.type": "org.apache.kafka.connect.transforms.TimestampConverter\$Value",
    "transforms.ConvertTimestamp.field": "@timestamp",
    "transforms.ConvertTimestamp.format": "yyyy-MM-dd'T'HH:mm:ss'Z'",
    "transforms.ConvertTimestamp.target.type": "Timestamp",
    "behavior.on.malformed.documents": "ignore"
  }
}
EOF
}


#echo "Payload: $(generate_payload)"

curl -X POST -H "Content-Type: application/json" --data "$(generate_payload)"  ccm-l2-kafka-node1:8083/connectors
echo -e "\n"
