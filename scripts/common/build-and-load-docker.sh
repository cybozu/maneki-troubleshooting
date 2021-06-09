#!/bin/sh -e

if [ $# -lt 1 ]; then
    exit 1
fi

CASE="${1}"
DOCKER="${2:-${1}}"
TAG="${3:-quay.io/cybozu/training-troubleshooting:1.0.1}"


docker build -t ${TAG} dockerfiles/${DOCKER}
kind load docker-image ${TAG} --name $(whoami)-${CASE}
