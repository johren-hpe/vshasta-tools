#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage:  $0 <node-name>"
    exit 1
fi

NODE=$1

kubectl get nodes --no-headers=true | awk '{print $1}' | grep -q "^${NODE}$" || { echo "ERROR: Invalid node name ${NODE}"; exit 1; }

while read -r a b; do
    echo "Restarting pod $b"
    kubectl -n $a delete pod $b
done < <(kubectl get pods -A -o json | jq -j --arg n "$NODE" '.items[] | select (.spec.nodeName==$n) | select(.spec.hostNetwork!=true) |.metadata.namespace, " ", .metadata.name, "\n"')


