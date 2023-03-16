#!/bin/bash
set -x

printf "\n### Installing basic update ###\n"
sudo apt-get update
sudo apt-get -y upgrade

printf "\n### Increase Open File Limit ###\n"
sudo sh -c 'echo "* hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* soft nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root hard nofile 64000" >> /etc/security/limits.conf'
sudo sh -c 'echo "root soft nofile 64000" >> /etc/security/limits.conf'

printf "\n### Installing Pritunl and Wireguard ###\n"
sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
deb https://repo.pritunl.com/stable/apt jammy main
EOF

sudo apt-get --assume-yes install gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A

sudo apt-get update

## Disabled in favour to `source_dest_check` option
# sudo apt-get --assume-yes install awscli jq
# EC2_INSTANCE_ID="`curl --silent http://169.254.169.254/latest/meta-data/instance-id`"
# EC2_INSTANCE_REGION="`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`"
# Disable Source/Destination Check for EC2 Instance ENI
# aws ec2 modify-instance-attribute --no-source-dest-check --instance-id $EC2_INSTANCE_ID --region $EC2_INSTANCE_REGION

sudo apt-get --assume-yes install pritunl wireguard-tools

sudo pritunl set-mongodb mongodb+srv://${atlas_dbuser}:${atlas_dbpassword}@${atlas_server_authority_address}/${pritunl_database}
sudo pritunl set app.reverse_proxy true
sudo pritunl set app.redirect_server true
sudo pritunl set app.server_ssl true
sudo pritunl set app.server_port 443

sudo systemctl start pritunl
sudo systemctl enable pritunl

# Apply and use the latets Kernel patches on the next reboot.
# sleep 10
# sudo /sbin/shutdown -r now
