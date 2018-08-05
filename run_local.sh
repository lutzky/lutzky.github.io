#!/bin/bash

set -e

port=${1:-8080}
docker_image="starefossen/github-pages"

docker pull $docker_image

echo
echo "Running on port ${port}"
echo

curdir=$(readlink -f $(dirname $0))

docker run -t --rm -v "$curdir":/usr/src/app -p "${port}:4000" $docker_image
