#!/usr/bin/env bash

set -o nounset
set -o errexit


cd "${BASH_SOURCE%/*}"

# Starte alle worker container mit docker compose
docker-compose up -d
sleep 5

SWARM_WORKER_JOIN_TOKEN=$(docker swarm join-token -q worker)
SWARM_MASTER_NODE_ADDR=$(docker info --format '{{ .Swarm.NodeAddr }}')

# let all worker nodes join the swarm

WORKERS=$(docker ps --filter label=docker-kurs=worker --format '{{ .ID }}')
for worker in ${WORKERS}; do
  worker_hostname=$(docker inspect ${worker} --format '{{ .Config.Hostname }}')
  echo ""
  echo "${worker_hostname} is going to join the swarm at ${SWARM_MASTER_NODE_ADDR}."
  docker exec -it ${worker} \
    docker swarm join --token ${SWARM_WORKER_JOIN_TOKEN} ${SWARM_MASTER_NODE_ADDR} || echo "${worker_hostname} has already joined a swarm."
done
