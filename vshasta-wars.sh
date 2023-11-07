#!/bin/bash
#
# Remove pod disruption budgets for NLS deployments that have been scaled down to 1 on vshasta
kubectl -n argo delete pdb cray-nls-argo-workflows-server
kubectl -n argo delete pdb cray-nls-argo-workflows-workflow-controller
kubectl -n argo delete pdb pdb-cray-cls

# Scale down istiod hpa so it doesn't take over all of the space during heavy load
#
kubectl -n istio-system patch hpa istiod --patch '{"spec":{"maxReplicas":4}}'

# Remove the redfish emulator to easy the load for drains
#
helm -n services delete csm-redfish-interface-emulator

# Remove SMA to eas the load for drains
#
helm -n sysmgmt-health delete cray-sysmgmt-health

pdsh -w ncn-m00[1-3],ncn-w00[1-3] sed -i '/goss-k8s-console-services.yaml/d' /opt/cray/tests/install/ncn/suites/ncn-cilium-migrate-tests.yaml 
