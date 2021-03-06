#!/bin/bash

yum install https://rdoproject.org/repos/openstack-pike/rdo-release-pike.rpm -y
yum install git ntp wget ntpdate openssh-server python-devel sudo '@Development Tools' -y

systemctl stop firewalld
systemctl mask firewalld

mkdir -p /opt/git/
cd /opt/git/
wget artifacts.opnfv.org/compass4nfv/package/openstack_pike.tar.gz
tar -zxvf openstack_pike.tar.gz
rm -rf openstack_pike.tar.gz
#cd openstack
#git clone https://github.com/openstack/tacker.git -b stable/pike
#cd tacker
#git checkout a0f1e680d81c7db66ae7a2a08c3d069901d0765a


git clone https://git.openstack.org/openstack/openstack-ansible /opt/openstack-ansible

cd /opt/openstack-ansible

#git checkout b962eed003580ee4c3bd69da911f20b3905a9176
#git checkout da37351ca0a96ed38de72f3e00a7549a024cb810
#git checkout 71110d6bc0f459b668948aca185139c1d79f0452
git checkout 16c69046bfd90d1b984de43bc6267fece6b75f1c

git checkout -b stable/pike

#/bin/cp -rf /opt/tacker_conf/ansible-role-requirements.yml /opt/openstack-ansible/
#/bin/cp -rf /opt/tacker_conf/openstack_services.yml /opt/openstack-ansible/playbooks/defaults/repo_packages/
#/bin/cp -rf /opt/tacker_conf/os-tacker-install.yml /opt/openstack-ansible/playbooks/
#/bin/cp -rf /opt/tacker_conf/setup-openstack.yml /opt/openstack-ansible/playbooks/
#/bin/cp -rf /opt/tacker_conf/tacker.yml /opt/openstack-ansible/playbooks/inventory/env.d/
#/bin/cp -rf /opt/tacker_conf/tacker_all.yml /opt/openstack-ansible/playbooks/inventory/group_vars/
#/bin/cp -rf /opt/tacker_conf/user_secrets.yml /opt/openstack-ansible/etc/openstack_deploy/
#/bin/cp -rf /opt/tacker_conf/haproxy_config.yml /opt/openstack-ansible/playbooks/vars/configs/

/bin/cp -rf /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

cd /opt/openstack-ansible

scripts/bootstrap-ansible.sh

rm -f /usr/local/bin/ansible-playbook

cd /opt/openstack-ansible/scripts/
python pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml

cd /opt/openstack-ansible/group_vars
sed -i 's/#repo_build_git_cache/repo_build_git_cache/g' repo_all.yml

cp /opt/setup-complete.yml /opt/openstack-ansible/playbooks/
echo "- include: setup-complete.yml" >> /opt/openstack-ansible/playbooks/setup-infrastructure.yml
