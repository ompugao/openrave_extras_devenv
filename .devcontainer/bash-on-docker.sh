#!/bin/bash
CONTAINER=${1:-app}
SCRIPTDIR=$(dirname $0)
# DOCKERCOMPOSEYML=./docker-compose.old.yml
DOCKERCOMPOSEYML=./docker-compose.yml
cd $SCRIPTDIR
set -e
bash ../set_xauth.sh
docker compose --project-name openrave_extras_devenv -f $DOCKERCOMPOSEYML up -d ${CONTAINER}
set +e
docker compose --project-name openrave_extras_devenv -f $DOCKERCOMPOSEYML exec --workdir /workspace ${CONTAINER} bash


