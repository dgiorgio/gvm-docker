#!/usr/bin/env bash

source /usr/local/bin/sshvpn_vars.sh

######################### function #########################

_PRINT() {
  echo -e "${MSG} ${STATUS}"
}

_VALID_DIRS() {
  for TEMP_VAR_DIR in $(echo ${LIST_DIR}); do
    MSG="Directory [${TEMP_VAR_DIR}] exists:"
    if [ -d "${TEMP_VAR_DIR}" ]; then
      STATUS="OK"
    else
      STATUS="ERRO"
    fi
    _PRINT
  done
}

_VALID_FILES() {
  for TEMP_VAR_FILES in $(echo ${LIST_FILES}); do
    MSG="File [${TEMP_VAR_FILES}] exists:"
    if [ -f "${TEMP_VAR_FILES}" ]; then
      STATUS="OK"
    else
      STATUS="ERRO"
    fi
    _PRINT
  done
}

_SSHKEY() {
  MSG="ssh key exists:"
  STATUS="ERRO"
  if [ ! -f "${HOME}/.ssh/id_rsa" ] && [ ! -f "${HOME}/.ssh/id_rsa.pub" ]; then
    (cat /dev/zero | ssh-keygen -q -N "") 1> /dev/null && \
    STATUS="CREATED"
  else
    STATUS="OK"
  fi
  _PRINT
}

######################### ssh-config #########################
LIST_DIR="
${SSHVPN_SSHCONFIGDEST}
${SSHVPN_SSHCONFIGDEST}/${SSHVPN_CONFIG_D}
${SSHVPN_SSHCONFIGDEST}/bin
"
_VALID_DIRS

rm -rf /root/.ssh
ln -s "${SSHVPN_SSHCONFIGDEST}" /root/.ssh

LIST_FILES="
${SSHVPN_SSHCONFIGDEST}/config
${SSHVPN_SSHCONFIGDEST}/${SSHVPN_CONFIG_D}/client
${SSHVPN_SSHCONFIGDEST}/${SSHVPN_CONFIG_D}/tunnel
"
# ${SSHVPN_SSHCONFIGDEST}/bin/script-vpn-local_server1.sh
# ${SSHVPN_SSHCONFIGDEST}/bin/script-vpn-remote_server1.sh

_VALID_FILES

_SSHKEY

######################### autossh #########################
LIST_DIR="${SSHVPN_AUTOSSHDEST}"
_VALID_DIRS

LIST_FILES="${SSHVPN_AUTOSSHDEST}/autossh-start.sh"
_VALID_FILES

chmod +x "${SSHVPN_AUTOSSHDEST}/autossh-start.sh"

######################### hosts #########################
LIST_DIR="${SSHVPN_HOSTSDEST}"
_VALID_DIRS

LIST_FILES="${SSHVPN_HOSTSDEST}/hosts"
_VALID_FILES

######################### network #########################

[ -d "/dev/net" ] || mkdir /dev/net
[ -e "/dev/net/tun" ] || mknod /dev/net/tun c 10 200

echo "1" >/proc/sys/net/ipv4/ip_forward

# Masquerade outgoing traffic
#iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Allow return traffic
iptables -A INPUT -i eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT

# Forward everything
iptables -A FORWARD -j ACCEPT
