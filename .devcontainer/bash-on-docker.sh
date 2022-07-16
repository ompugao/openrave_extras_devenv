#!/bin/bash
CONTAINER=${1:-app}
SCRIPTDIR=$(dirname $0)
cd $SCRIPTDIR
set -e
bash ../set_xauth.sh
docker-compose --project-name openrave_extras_devenv -f ./docker-compose.yml up -d ${CONTAINER}
set +e
docker-compose --project-name openrave_extras_devenv exec --workdir /workspace ${CONTAINER} bash


