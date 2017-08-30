#!/bin/bash

yum install https://rdoproject.org/repos/openstack-ocata/rdo-release-ocata.rpm -y
yum install git ntp wget ntpdate openssh-server python-devel sudo '@Development Tools' -y

mkdir -p /opt/git/
cd /opt/git/
wget artifacts.opnfv.org/compass4nfv/package/openstack.tar.gz
tar -zxvf openstack.tar.gz
rm -rf openstack.tar.gz

git clone https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible

cd /opt/openstack-ansible

git checkout 7beba50a8345616ef27c70cbbcac962b56b8adc5

/bin/cp -rf /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

cd /opt/openstack-ansible

scripts/bootstrap-ansible.sh

rm -f /usr/local/bin/ansible-playbook

cd /opt/openstack-ansible/scripts/
python pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml

cd /opt/openstack-ansible/playbooks/inventory/group_vars
sed -i 's/#repo_build_git_cache/repo_build_git_cache/g' repo_all.yml
