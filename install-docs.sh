#!/bin/sh
#
set -e

# pit always seems to need the key removed for m001
ssh-keygen -R ncn-m001 -f /root/.ssh/known_hosts

csm_path=$(find /var/www/ephemeral -type d -name "csm-*" | head -1)
ncns="ncn-m001 ncn-m002 ncn-m003"
for package_name in docs-csm; do
    package_file=$(find ${csm_path}/rpm/cray/csm  -name "${package_name}-*.rpm")
    echo "Installing $(basename ${package_file}) on pit ..."
    rpm -i --force --replacepkgs ${package_file}
    for ncn in ${ncns}; do
        echo "Installing $(basename ${package_file}) on ${ncn} ..."
        scp -o StrictHostKeyChecking=no ${package_file} root@${ncn}:/tmp
        ssh -o StrictHostKeyChecking=no root@${ncn} rpm -i --force --replacepkgs /tmp/$(basename ${package_file})
    done
done
