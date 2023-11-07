
PITPORT=9305
LOCALPORT=9305
SERVICE_NAME=cray-nls-argo-workflows-server

if [ $# -eq 0 ]; then
  SERVICEIP=$(kubectl get service -A | grep ${SERVICE_NAME} | awk '{print $4}')
  SERVICEPORT=$(kubectl get service -A | grep ${SERVICE_NAME} | awk '{print $6}' | cut -d'/' -f 1)

  ssh -o ExitOnForwardFailure=yes -f -N -L localhost:${PITPORT}:${SERVICEIP}:${SERVICEPORT} ncn-w001

  if [ $? -ne 0 ]; then
    echo "Failed to set up ${SERVICE_NAME} on port ${PITPORT}"
    exit 1
  fi

  echo "Set up ${SERVICE_NAME} on port ${PITPORT}"
fi

echo "Select a LOCALPORT and run the following on your laptop:"
echo "  gcloud compute --project ${VSHASTA_PROJECT_ID} ssh root@pit --zone=us-central1-b -- -L ${LOCALPORT}:localhost:${PITPORT}"

