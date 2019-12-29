#!/usr/bin/env bash

DOCKER_REPO="${DOCKER_REPO:-minyk}"

pushd docker

POLYNOTE_VERSION="${1:-0.2.15}"
BUILD_OPTS="--build-arg POLYNOTE_VERSION=${POLYNOTE_VERSION}"

if [ ${NO_CACHE:-"0"} == "1" ]; then
  export BUILD_OPTS="${BUILD_OPTS} --no-cache"
fi

DOCKER_TAG=0.1-${POLYNOTE_VERSION}-2.4.3
echo "Building ploynote:${DOCKER_TAG}"
docker build -t polynote:${DOCKER_TAG} ${BUILD_OPTS} .
if [ ${PUSH:-"0"} == "1" ]; then
  docker tag polynote:${DOCKER_TAG} ${DOCKER_REPO}/polynote:${DOCKER_TAG}
  docker push ${DOCKER_REPO}/polynote:${DOCKER_TAG}
fi

popd
