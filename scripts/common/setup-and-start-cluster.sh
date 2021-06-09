#!/bin/sh -e

if [ $# -lt 1 ]; then
    exit 1
fi

if [ -d work ]; then
    echo "another scenario is active. Run make stop first"
    exit 1
fi

CASE="${1}"
IP=""
while [ "${IP}" = "" ]; do
    TEMP_IP="127.0.0.$(shuf -i 2-254 -n 1)"
    if [ "$(ss -Htl sport = :http src ${TEMP_IP})" = "" ]; then
        IP=${TEMP_IP}
        break
    fi
done
if [ "${IP}" = "" ]; then
    exit 1
fi

mkdir -p work

sed "s/_LISTEN_ADDRESS_/${IP}/g" clusters/cluster.yaml > work/cluster.yaml

kind create cluster --name=$(whoami)-${CASE} --config work/cluster.yaml
until kustomize build manifests/admin | kubectl apply -f - ; do
    sleep 3
done

until [ "$(kubectl get pods -A --field-selector=status.phase!=Running 2>&1)" = "No resources found" ] ; do
    sleep 3
done

echo "${IP} $(whoami)" | sudo tee -a /etc/hosts
echo "${IP}" > work/ip-alias
