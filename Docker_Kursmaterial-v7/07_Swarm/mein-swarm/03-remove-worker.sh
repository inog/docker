#!/usr/bin/env bash

set -o nounset
set -o errexit


cd "${BASH_SOURCE%/*}"


# lasse alle worker nodes den swarm verlassen
WORKERS=$(docker ps --filter label=docker-kurs=worker --format '{{ .ID }}')
for worker in ${WORKERS}; do
  worker_hostname=$(docker inspect ${worker} --format '{{ .Config.Hostname }}')
  echo "\n${worker_hostname} verlässt den swarm."
  docker exec -it ${worker} \
    docker swarm leave || echo "${worker_hostname} hat den swarm verlassen."
done

# Schließe alle container mit docker-compose
docker-compose down
