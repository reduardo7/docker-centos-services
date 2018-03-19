# https://forums.docker.com/t/any-simple-and-safe-way-to-start-services-on-centos7-systemd/5695/8?u=reduardo7

##################
# Setup CentOS 7 #
##################

FROM centos:7

RUN yum install -y \
    initscripts epel-release \
    bind bind-utils rpcbind bridge-utils iptables-services \
    net-tools sudo \
    openssh-server openssh-clients

RUN systemctl enable named.service
RUN systemctl enable iptables.service

##############
# SSH Config #
##############

RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN systemctl enable sshd.service

###########
# Cleanup #
###########

RUN yum clean all

#######
# Run #
#######

# Without this, init won't start the enabled services and exec'ing and starting
# them reports "Failed to get D-Bus connection: Operation not permitted".
VOLUME /run /tmp

COPY scripts/docker-fixes.service /usr/lib/systemd/system/docker-fixes.service
COPY scripts/docker-fixes.sh /etc/docker-fixes.sh
RUN systemctl enable docker-fixes.service

CMD /usr/sbin/init

# vim: syntax=Docker ts=4 sw=4 sts=4 sr noet st ai si
