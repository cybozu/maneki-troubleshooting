#!/bin/sh

IP=$(cat work/ip-alias)
if [ "${IP}" = "" ]; then
    exit 1
fi

sudo sed -i "/${IP} $(whoami)/d" /etc/hosts

kind delete cluster --name=$(kind get clusters | grep $(whoami)-case)
rm -rf work
