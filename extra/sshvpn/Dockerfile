FROM fedora:29

### Install System Base
RUN dnf install -y \
openssh-clients \
iputils \
iproute \
net-tools \
autossh \
procps-ng \
nc \
iptables \
&& dnf clean all -y \
&& rm -rf /var/cache/dnf

### Start
COPY sshvpn_vars.sh /usr/local/bin
RUN chmod +x /usr/local/bin/sshvpn_vars.sh
COPY sshvpn_createlinks.sh /usr/local/bin
RUN chmod +x /usr/local/bin/sshvpn_createlinks.sh
COPY sshvpn_valid.sh /usr/local/bin
RUN chmod +x /usr/local/bin/sshvpn_valid.sh
COPY docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
