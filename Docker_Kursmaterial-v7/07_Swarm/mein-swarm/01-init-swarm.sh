#!/usr/bin/env bash

set -o nounset
set -o errexit


cd "${BASH_SOURCE%/*}"

# Starte den swarm 
# ACHTUNG: bei Windows Toolbox muss noch die IP übergeben werden. Schaue dir dazu das Video an

if [ "$(docker info --format '{{ .Swarm.LocalNodeState }}')" == "inactive" ];then
  echo "Initialisiere den swarm manager."
  docker swarm init
fi

SWARM_MASTER_NODE_ADDR=$(docker info --format '{{ .Swarm.NodeAddr }}')

echo "Der Swarm Manager ist unter der folgenden IP erreichbar: ${SWARM_MASTER_NODE_ADDR}."
