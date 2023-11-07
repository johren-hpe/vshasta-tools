#!/bin/bash
#
#
# Create netpol directory if it doesn't exist
mkdir -p /root/tools/netpol

for i in $(kubectl get netpol -A --no-headers | awk '{print $1}' | sort | uniq);do 
  echo "--- namespace ${i} ---"
  for j in $(kubectl -n ${i} get netpol --no-headers | awk '{print $1}');do 
    echo "Saving off network policy ${j}"
    echo "---" >> /root/tools/netpol/netpol.yaml
    kubectl -n ${i} get netpol ${j} -o yaml >> /root/tools/netpol/netpol.yaml
    echo "Removing network policy ${j}"
    kubectl -n ${i} delete netpol ${j}
  done
done
