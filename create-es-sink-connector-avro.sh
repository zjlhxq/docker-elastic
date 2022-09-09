#!/bin/bash
#export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081,http://ccm-l2-kafka-node2:8081,http://ccm-l2-kafka-node3:8081"
export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081"

generate_payload() {
cat <<EOF
{
  "name": "es-sink-connector-avro",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "connection.url": "http://ccm-l2-kafka-node1:9200",
    "topics": "ccm1-tcp-inbound-data-deserialized,ccm2-tcp-inbound-data-deserialized,ccm1-plc-inbound-raw-data,ccm2-plc-inbound-raw-data,ccm1-plc-inbound-raw-data-passthrough,ccm2-plc-inbound-raw-data-passthrough,ccm1-event-log-records,ccm2-event-log-records",
    "key.ignore": "true",
    "tasks.max": 1,
    "type.name": "_doc", 
    "transforms": "InsertTimestamp,ConvertTimestamp",
    "transforms.InsertTimestamp.type": "org.apache.kafka.connect.transforms.InsertField\$Value",
    "transforms.InsertTimestamp.timestamp.field": "@timestamp",
    "transforms.ConvertTimestamp.type": "org.apache.kafka.connect.transforms.TimestampConverter\$Value",
    "transforms.ConvertTimestamp.field": "@timestamp",
    "transforms.ConvertTimestamp.format": "yyyy-MM-dd'T'HH:mm:ss'Z'",
    "transforms.ConvertTimestamp.target.type": "string",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "$SCHEMA_REGISTRY_URL",
    "value.converter.value.subject.name.strategy": "io.confluent.kafka.serializers.subject.RecordNameStrategy",
    "value.converter.enhanced.avro.schema.support": true,
    "consumer.auto.offset.reset": "earliest",
    "behavior.on.malformed.documents": "ignore"
  }
}
EOF
}


#echo "Payload: $(generate_payload)"

curl -X POST -H "Content-Type: application/json" --data "$(generate_payload)"  ccm-l2-kafka-node1:8083/connectors
echo -e "\n"
