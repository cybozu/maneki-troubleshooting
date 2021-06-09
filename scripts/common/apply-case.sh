#!/bin/sh

if [ $# -lt 1 ]; then
    exit 1
fi

CASE="${1}"

kustomize build manifests/overlays/${CASE} > work/case.yaml

until kubectl apply -f work/case.yaml ; do
    sleep 3
done
