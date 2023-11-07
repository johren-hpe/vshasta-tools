#!/bin/bash
#
NODE=$1

NETWORK_TEST_FAIL=1

for i in `seq 1 3`; do
  echo "Run test"
  testresult=$(kubectl -n kube-system run --attach --rm --restart=Never verify-network --overrides='{"spec": {"nodeName": "'$NODE'", "tolerations": [{"operator": "Exists"}]}}' --image ghcr.io/nicolaka/netshoot:v0.8 -- /bin/bash -c 'ip -br addr && curl -s -k https://$KUBERNETES_SERVICE_HOST/healthz && echo' 2>&1)
  echo "Network test status: $?"
  echo "$testresult"
  if [[ ! "$testresult" =~ "timed out waiting for the condition" ]]; then
    NETWORK_TEST_FAIL=0
    break
  else
    echo "Trying network test again..."
  fi
done
     
if [ $NETWORK_TEST_FAIL -eq 1 ]; then
    echo "Network tests did not pass"
    exit 1
fi

echo "Network tests PASSED"
exit 0
