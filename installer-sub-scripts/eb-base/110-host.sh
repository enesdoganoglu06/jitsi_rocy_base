#!/bin/bash

# ------------------------------------------------------------------------------
# HOST.SH
# ------------------------------------------------------------------------------
set -e
source $INSTALLER/000-source

# ------------------------------------------------------------------------------
# ENVIRONMENT
# ------------------------------------------------------------------------------
MACH="$TAG-host"
cd $MACHINES/$MACH

# ------------------------------------------------------------------------------
# INIT
# ------------------------------------------------------------------------------
# [[ "$DONT_RUN_HOST" = true ]] && exit

echo
echo "-------------------------- HOST ---------------------------"

# ------------------------------------------------------------------------------
# BACKUP & STATUS
# ------------------------------------------------------------------------------
OLD_FILES="/root/$TAG-old-files/$DATE"
mkdir -p $OLD_FILES

# process status
echo "# ----- ps auxfw -----" >> $OLD_FILES/ps.status
ps auxfw >> $OLD_FILES/ps.status

# deb status
echo "# ----- dpkg -l -----" >> $OLD_FILES/dpkg.status
dpkg -l >> $OLD_FILES/dpkg.status

# ------------------------------------------------------------------------------
# PACKAGES
# ------------------------------------------------------------------------------
# export DEBIAN_FRONTEND=noninteractive

# load the bridge module before the possible kernel update
[[ -n "$(command -v modprobe)" ]] && [[ -z "$(lsmod | grep bridge)" ]] && \
    modprobe bridge
# load the veth module before the possible kernel update
[[ -n "$(command -v modprobe)" ]] && [[ -z "$(lsmod | grep veth)" ]] && \
    modprobe veth

# upgrade
dnf install -y epel-release
dnf $APT_PROXY -y update
dnf $APT_PROXY -y upgrade
dnf $APT_PROXY -y install dnf-utils

# added packages
dnf $APT_PROXY -y install lxc bridge-utils lxc-templates container-selinux
dnf $APT_PROXY -y install dnsmasq dnsutils
dnf $APT_PROXY -y install xz gnupg pwgen
dnf $APT_PROXY -y install wget curl ca-certificates
dnf $APT_PROXY -y install iputils
