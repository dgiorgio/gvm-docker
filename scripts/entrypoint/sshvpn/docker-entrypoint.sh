#!/usr/bin/env bash

ENABLE_CRON_DEFAULT="false"
[ "${ENABLE_CRON}" != "true" ] && ENABLE_CRON="${ENABLE_CRON_DEFAULT}"

[ "${SSHVPN_ROOT_DOCKER}" == "" ] && SSHVPN_ROOT_DOCKER="/root/sshvpn-files"
[ "${SSHVPN_INTERFACE_IP}" == "" ] && SSHVPN_INTERFACE_IP="172.66.66.66"
[ "${SSHVPN_ROUTE_RANGE}" == "" ] && SSHVPN_ROUTE_RANGE="10.166.0.0/16"
[ "${SSHVPN_INTERFACE}" == "" ] && SSHVPN_INTERFACE="eth0"

ldconfig

/usr/bin/redis-server /etc/redis.conf --daemonize yes

_REDIS-CHECK() {
  REDIS_RESULT="$(/usr/bin/redis-cli ping)"
}

echo "Testing redis status..."
_REDIS-CHECK

while [ "${REDIS_RESULT}" != "PONG" ]; do
  echo "Redis not yet ready..."
  sleep 1
  _REDIS-CHECK
done
echo "Redis ready."

/usr/local/bin/greenbone-setup.sh
/usr/local/bin/greenbone-cron.sh "${ENABLE_CRON}"

>> /usr/local/var/log/gvm/openvassd.log

echo "openvas-scanner - creating cache..."
/usr/local/sbin/openvassd -C >/dev/null 2>&1
echo "openvas-scanner - starting..."
/usr/local/sbin/openvassd
sleep 10

gvmd -v --listen=0.0.0.0 --port=9390

echo "create route [ ${SSHVPN_ROUTE_RANGE} -> ${SSHVPN_INTERFACE_IP} on ${SSHVPN_INTERFACE} ]"
ip route add ${SSHVPN_ROUTE_RANGE} via ${SSHVPN_INTERFACE_IP} dev ${SSHVPN_INTERFACE}

tail -f /usr/local/var/log/gvm/* &

while true; do
  # update hosts
  cat "${SSHVPN_ROOT_DOCKER}/hosts/hosts" > /etc/hosts && \
  echo "$(date +%Y%m%dT%H%M%S) - /etc/hosts updated!"

  sleep 1m
done
