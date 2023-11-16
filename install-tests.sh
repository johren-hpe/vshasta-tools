#!/bin/sh
#
set -e

# pit always seems to need the key removed for m001
ssh-keygen -R ncn-m001 -f /root/.ssh/known_hosts

csm_path=$(find /var/www/ephemeral -type d -name "csm-*" | head -1)
ncns="ncn-m001 ncn-m002 ncn-m003 ncn-w001 ncn-w002 ncn-w003 ncn-s001 ncn-s002 ncn-s003" 
for package_name in csm-testing goss-servers hpe-csm-goss-package cray-cmstools-crayctldeploy; do
    package_file=$(find ${csm_path}/rpm/cray/csm  -name "${package_name}-*.rpm")
    echo "Installing $(basename ${package_file}) on pit ..."
    rpm -i --force --replacepkgs ${package_file}
    if [ "${package_name}" == goss-servers ]; then
        systemctl daemon-reload
        systemctl restart goss-servers
    fi
    for ncn in ${ncns}; do
        echo "Installing $(basename ${package_file}) on ${ncn} ..."
        scp -o StrictHostKeyChecking=no ${package_file} root@${ncn}:/tmp
        ssh -o StrictHostKeyChecking=no root@${ncn} rpm -i --force --replacepkgs /tmp/$(basename ${package_file})
        if [ "${package_name}" == goss-servers ]; then
            ssh -o StrictHostKeyChecking=no root@${ncn} 'systemctl daemon-reload; systemctl restart goss-servers'
        fi
    done
done
