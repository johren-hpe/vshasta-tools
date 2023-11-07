#!/bin/bash
#
#
# Create netpol directory if it doesn't exist
NETPOLDIR=/root/tools/netpol

for i in $(ls $NETPOLDIR); do 
  kubectl apply -f ${NETPOLDIR}/${i}
done
