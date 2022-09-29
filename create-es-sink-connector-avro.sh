#!/bin/bash
#export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081,http://ccm-l2-kafka-node2:8081,http://ccm-l2-kafka-node3:8081"
export SCHEMA_REGISTRY_URL="http://ccm-l2-kafka-node1:8081"

generate_payload() {
cat <<EOF
{
  "name": "es-sink-connector-canonical-F",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "connection.url": "http://ccm-l2-kafka-node1:9200",
    "topics": "ccm1-tcp-inbound-data-deserialized,ccm2-tcp-inbound-data-deserialized,ccm1-plc-inbound-raw-data,ccm2-plc-inbound-raw-data,ccm1-plc-inbound-raw-data-passthrough,ccm2-plc-inbound-raw-data-passthrough,ccm1-event-log-records,ccm2-event-log-records,ccm1-tcp-outbound-data-processed,ccm2-tcp-outbound-data-processed,ccm1-plc-outbound--tcs-hsa-s1,ccm1-plc-outbound--tcs-hsa-s2,ccm1-plc-outbound--tcs-nonhsa-s1,ccm1-plc-outbound--tcs-nonhsa-s2,ccm1-plc-outbound-common,ccm1-plc-outbound-data,ccm1-plc-outbound-drive-tcm-marker-s1,ccm1-plc-outbound-drive-tcm-marker-s2,ccm1-plc-outbound-instrument-s1,ccm1-plc-outbound-instrument-s2,ccm1-plc-outbound-raw-data,ccm1-plc-outbound-raw-data-common,ccm1-plc-outbound-raw-data-strand1,ccm1-plc-outbound-raw-data-strand2,ccm1-plc-outbound-tcs-hsa-s1,ccm1-plc-outbound-tcs-hsa-s2,ccm1-plc-outbound-tcs-nonhsa-s1,ccm1-plc-outbound-tcs-nonhsa-s2,ccm2-plc-outbound--tcs-hsa-s1,ccm2-plc-outbound--tcs-hsa-s2,ccm2-plc-outbound--tcs-nonhsa-s1,ccm2-plc-outbound--tcs-nonhsa-s2,ccm2-plc-outbound-common,ccm2-plc-outbound-data,ccm2-plc-outbound-drive-tcm-marker-s2,ccm2-plc-outbound-drive-tcm-marker-s2,ccm2-plc-outbound-instrument-s1,ccm2-plc-outbound-instrument-s2,ccm2-plc-outbound-raw-data,ccm2-plc-outbound-raw-data-common,ccm2-plc-outbound-raw-data-strand1,ccm2-plc-outbound-raw-data-strand2,ccm2-plc-outbound-tcs-hsa-s1,ccm2-plc-outbound-tcs-hsa-s2,ccm2-plc-outbound-tcs-nonhsa-s1,ccm2-plc-outbound-tcs-nonhsa-s2,ccm1-plc-data-preprocessed,ccm2-plc-data-preprocessed",
    "key.ignore": "true",
    "schema.ignore": "false",
    "tasks.max": 5,
    "type.name": "_doc", 
    "transforms": "ExtractTimestamp,ConvertTimestamp",
    "transforms.ExtractTimestamp.type": "org.apache.kafka.connect.transforms.InsertField\$Value",
    "transforms.ExtractTimestamp.timestamp.field": "@timestamp",
    "transforms.ConvertTimestamp.type": "org.apache.kafka.connect.transforms.TimestampConverter\$Value",
    "transforms.ConvertTimestamp.field": "@timestamp",
    "transforms.ConvertTimestamp.format": "yyyy-MM-dd'T'HH:mm:ss'Z'",
    "transforms.ConvertTimestamp.target.type": "Timestamp",
    "value.converter": "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url": "$SCHEMA_REGISTRY_URL",
    "value.converter.value.subject.name.strategy": "io.confluent.kafka.serializers.subject.RecordNameStrategy",
    "value.converter.enhanced.avro.schema.support": "true",
    "consumer.auto.offset.reset": "earliest",
    "behavior.on.malformed.documents": "warn",
    "errors.tolerance": "all",
    "errors.log.enable": "true",
    "errors.log.include,message": "true"
  }
}
EOF
}


#echo "Payload: $(generate_payload)"

curl -X POST -H "Content-Type: application/json" --data "$(generate_payload)"  ccm-l2-kafka-node1:8083/connectors
echo -e "\n"
