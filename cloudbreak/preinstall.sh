#!/bin/bash
cbserver="CLOUDBREAKSERVER"
tee ~/.ssh/id_rsa << EOF
{KEY}
EOF
chmod 600 ~/.ssh/id_rsa
pip-2.7 install requests --upgrade
cd ~/
rsync -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' -arP cloudbreak@1$cbserver:~/ambari-ssl-wizard ./
cd ambari-ssl-wizard
hostname -f  > hosts
./certificate-generator.sh LocalAuthority configs

if yum list installed | grep ambari-server; then
ambari-server setup-security --security-option=setup-truststore --truststore-reconfigure --truststore-type=jks --truststore-path=/etc/security/pki/truststore.jks --truststore-password=`cat configs | grep TrustStorePassword | cut -d "=" -f 2`
fi
