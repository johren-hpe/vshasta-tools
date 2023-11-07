#!/bin/bash
#

ts=$(date +'%Y-%m-%d-%H-%M')
resultsdir=testresults/${ts}
mkdir -p ${resultsdir} 
curl -Ss --max-time 3600 http://ncn-m002:8997/ncn-healthcheck-master > ${resultsdir}/m002-master
curl -Ss --max-time 3600 http://ncn-m002:8998/ncn-healthcheck-master-single > ${resultsdir}/m002-master-single
curl -Ss --max-time 3600 http://ncn-m003:8997/ncn-healthcheck-master  > ${resultsdir}/m003-master
curl -Ss --max-time 3600 http://ncn-w001:8997/ncn-healthcheck-worker  > ${resultsdir}/w001-worker
curl -Ss --max-time 3600 http://ncn-w001:8998/ncn-healthcheck-worker-single > ${resultsdir}/w001-worker-single
curl -Ss --max-time 3600 http://ncn-w001:9005/ncn-cms-tests  > ${resultsdir}/w001-cms
curl -Ss --max-time 3600 http://ncn-w002:8997/ncn-healthcheck-worker  > ${resultsdir}/w002-worker
curl -Ss --max-time 3600 http://ncn-w003:8997/ncn-healthcheck-worker  > ${resultsdir}/w003-worker
curl -Ss --max-time 3600 http://ncn-s001:8997/ncn-healthcheck-storage  > ${resultsdir}/s001-storage
curl -Ss --max-time 3600 http://ncn-s002:8997/ncn-healthcheck-storage  > ${resultsdir}/s002-storage
curl -Ss --max-time 3600 http://ncn-s003:8997/ncn-healthcheck-storage > ${resultsdir}/s003-storage  
