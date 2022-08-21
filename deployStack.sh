#!/bin/bash

docker network create --driver overlay --attachable elk_network
docker stack deploy --compose-file docker-compose.yml elastic
