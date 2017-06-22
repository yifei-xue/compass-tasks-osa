FROM huangxiangyu/compass-tasks:v0.2
#FROM localbuild/compass-tasks

RUN yum install https://rdoproject.org/repos/openstack-ocata/rdo-release-ocata.rpm -y && \
    yum install git ntp ntpdate openssh-server python-devel sudo '@Development Tools' -y


RUN git clone https://github.com/Justin-chi/compass-tasks-osa.git /opt/compass-tasks-osa
RUN mkdir -p /opt/git
RUN cp /opt/compass-tasks-osa/* /opt/git/
RUN /opt/git/run.sh

RUN cd /opt/openstack-ansible && \
    git checkout 7beba50a8345616ef27c70cbbcac962b56b8adc5

RUN /bin/cp -rf /opt/openstack-ansible/etc/openstack_deploy /etc/openstack_deploy

#bootstrap to download the install module and posting openstack-ansible
RUN cd /opt/openstack-ansible && \
    scripts/bootstrap-ansible.sh

RUN rm -f /usr/local/bin/ansible-playbook

RUN cd /opt/openstack-ansible/scripts/ && \
    python pw-token-gen.py --file /etc/openstack_deploy/user_secrets.yml

RUN cd /opt/openstack-ansible/playbooks/inventory/group_vars && \
    sed -i 's/#repo_build_git_cache/repo_build_git_cache/g' repo_all.yml
