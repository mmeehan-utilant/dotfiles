#!/bin/bash
###############################################
# user_data                                   #
#                                             #
#    This script, called by the EC2 user data #
# at instance first launch, sets up the dev   #
# environment. It is run as root.             #
#                                             #
###############################################

set -euxo pipefail

NONROOT_USER=ubuntu

export DEBIAN_FRONTEND=noninteractive

apt-get -y update

# Install zsh
apt-get -y install zsh
cp -p /etc/pam.d/chsh /etc/pam.d/chsh.backup
sed -ri "s|auth( )+required( )+pam_shells.so|auth sufficient pam_shells.so|" /etc/pam.d/chsh

apt-get -y install tmux

# Install mount_volume script
cp -p mount_volume.sh /usr/local/bin/mount_volume
chown ${NONROOT_USER}: /usr/local/bin/mount_volume

# Install add-jupyter-kernel script
cp -p add-jupyter-kernel /usr/local/bin/add-jupyter-kernel
chown ${NONROOT_USER}: /usr/local/bin/add-jupyter-kernel

unset DEBIAN_FRONTEND

exit 0
