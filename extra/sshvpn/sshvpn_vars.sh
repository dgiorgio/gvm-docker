#!/usr/bin/env bash

[ "${SSHVPN_ROOT_DOCKER}" == "" ] && SSHVPN_ROOT_DOCKER="${HOME}/sshvpn-files"
[ "${SSHVPN_AUTOSSHDEST}" == "" ] && SSHVPN_AUTOSSHDEST="${SSHVPN_ROOT_DOCKER}/autossh"
[ "${SSHVPN_HOSTSDEST}" == "" ] && SSHVPN_HOSTSDEST="${SSHVPN_ROOT_DOCKER}/hosts"
[ "${SSHVPN_SSHCONFIGDEST}" == "" ] && SSHVPN_SSHCONFIGDEST="${SSHVPN_ROOT_DOCKER}/ssh-config"
[ "${SSHVPN_CONFIG_D}" == "" ] && SSHVPN_CONFIG_D="sshvpn-config.d"
