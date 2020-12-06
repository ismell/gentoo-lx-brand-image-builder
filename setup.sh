#!/bin/bash

if [[ -v TRACE ]] && [[ -n $TRACE ]]; then
	export PS4='[\D{%FT%TZ}] ${BASH_SOURCE}:${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
	set -o xtrace
fi


# See https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base

source /etc/profile

set -eu -o pipefail

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

echo '==> Updating system'
emerge -1vuUDj @world
emerge --depclean

echo '==> Installing default packages'
emerge -tjv \
	app-editors/vim \
	app-portage/gentoolkit \
	dev-vcs/git \
	sys-apps/sdc-vmtools

# We need to patch openrc to support container=zone
# TODO: Send patch upstream
echo '==> Rebuilding OpenRC'
emerge -j sys-apps/openrc

rc-update add sdc-init boot
rc-update add sshd default
rc-update del kmod-static-nodes sysinit
rc-update del udev sysinit
rc-update del udev-trigger sysinit

echo '==> Disabling ttys'
sed -E -i \
    -e 's/^(c[0-9])/#\1/' \
    -e '/# TERMINALS/a # LX zones do not support ttys' \
    /etc/inittab

# Remove our temp version. I it will be regenerated on 1st boot.
rm /etc/resolv.conf
