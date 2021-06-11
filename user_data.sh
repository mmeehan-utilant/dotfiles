#!/bin/bash
###############################################
# user_data                                   #
#                                             #
#    This script, called by the EC2 user data #
# at instance first launch, sets up the dev   #
# environment. It is run as root, and will:   #
# * Update the apt-get repository listings    #
# * Install zsh                               #
# * Install Python3 and pip if needed         #
# * Install Emacs                             #
# * Install pyenv and pyenv-virtualenv        #
# * Install tmux                              #
# * Install curl, htop, & unzip               #
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

# Install pyenv prerequisites
sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
     libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
     xz-utils tk-dev libffi-dev liblzma-dev python-openssl git

# Install mount_volume script
cp -p mount_volume.sh /usr/local/bin/mount_volume
chown ${NONROOT_USER}: /usr/local/bin/mount_volume

# Install add-jupyter-kernel script
cp -p add-jupyter-kernel /usr/local/bin/add-jupyter-kernel
chown ${NONROOT_USER}: /usr/local/bin/add-jupyter-kernel

# Install emacs
apt-get -y install emacs

# Install python3 & pip
apt-get install -y \
	python3 \
	python3-pip

# Install other tools
apt-get -y install \
	curl \
	docker \
	htop \
	tmux \
	unzip

unset DEBIAN_FRONTEND

exit 0
