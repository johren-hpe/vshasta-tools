#!/bin/bash

if [ $# -lt 1 ]; then
    echo "Usage:  $0 argo|hubble|prometheus|grafana|all [ check ]"
    exit 1
fi

if [ "$1" == "all" ]; then
  SERVICES="argo hubble grafana prometheus"
else
  SERVICES="$1"
fi

for svc in $SERVICES; do

  lcsvc=$(echo "$svc" | awk '{print tolower($0)}')

  case $lcsvc in

    argo)
      PITPORT=9305 
      LOCALPORT=9305
      SERVICE_NAME=cray-nls-argo-workflows-server
      ;;
  
    hubble)
      PITPORT=9005 
      LOCALPORT=9005
      SERVICE_NAME=hubble-ui
      ;;

    grafana)
      PITPORT=9205 
      LOCALPORT=9205
      SERVICE_NAME=cray-sysmgmt-health-grafana
      ;;

    prometheus)
      PITPORT=9105 
      LOCALPORT=9105
      SERVICE_NAME=cray-sysmgmt-health-kube-p-prometheus
      ;;

    *)
      echo "Invalid service $svc"
      continue 
      ;;
  esac

  if [ $# -eq 2 ] && [ "$2" == "check" ]; then
    ps ax | grep ssh | grep -q localhost:${PITPORT}
    if [ $? -ne 0 ]; then
      echo "$svc not set up"
    else
      echo "Run the following on your laptop for ${svc}"
      echo "  gcloud compute --project ${VSHASTA_PROJECT_ID} ssh root@pit --zone=us-central1-b -- -L ${LOCALPORT}:localhost:${PITPORT}"
    fi
  else
    SERVICEIP=$(kubectl get service -A | grep ${SERVICE_NAME} | awk '{print $4}')
    SERVICEPORT=$(kubectl get service -A | grep ${SERVICE_NAME} | awk '{print $6}' | cut -d'/' -f 1)

    if [ -z ${SERVICEIP} ] || [ -z ${SERVICEPORT} ]; then
      echo "Could not find k8s service for ${svc}"
      continue
    fi

    ssh -o ExitOnForwardFailure=yes -f -N -L localhost:${PITPORT}:${SERVICEIP}:${SERVICEPORT} ncn-w001

    if [ $? -ne 0 ]; then
      echo "Failed to set up ${SERVICE_NAME} on port ${PITPORT}"
      continue
    fi

    echo "Set up ${SERVICE_NAME} on port ${PITPORT}"
  fi
done

