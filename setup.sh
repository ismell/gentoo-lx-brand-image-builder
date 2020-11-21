#!/bin/bash

if [[ -n $TRACE ]]; then
	export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
	set -o xtrace
fi


# See https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base

source /etc/profile
export PS1="(chroot) ${PS1}"

echo '==> Using 8.8.8.8 as nameserver'
cat >/etc/resolv.conf <<EOL
nameserver 8.8.8.8
EOL

echo '==> Enabling gentoo porage repo'

mkdir --parents /etc/portage/repos.conf
cp -fv /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf

echo '==> Downloading latest portage snapshot'
emerge-webrsync

eselect news read

echo '==> Setting timezone to UTC'
echo "UTC" > /etc/timezone
emerge --config sys-libs/timezone-data

echo '==> Generating locales'
cat >/etc/locale.gen <<EOL
en_US ISO-8859-1
en_US.UTF-8 UTF-8
C.UTF8 UTF-8
EOL
locale-gen

echo '==> Setting locale to en_US utf8'
eselect locale set en_US.utf8

# Use the updated environment
env-update
source /etc/profile

# Set random root pw
passwd -d root

echo '==> Installing default packages'
emerge -tjv \
	app-editors/vim \
	app-portage/gentoolkit

rc-update add sshd default
