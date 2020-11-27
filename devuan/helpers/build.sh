#!/bin/sh
set -ex
echo Installing Devuan $DEVUAN_RELEASE
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -yq apt-utils
apt-get install -yq \
    vim \
    binutils \
    openssh-server \
    sudo \
    iproute2 \
    curl \
    lsb-release \
    less \
    joe \
    man-db \
    net-tools \
    iputils-ping
# Remove the elogind session manager - this will cause the alternative
# consolekit to be installed automatically
apt-get remove -yq elogind
apt-get -qq clean
apt-get -qq autoremove

# disable services we do not need
for s in checkroot-bootclean.sh; do
	update-rc.d $s defaults-disabled
done

# Prevents apt-get upgrade issue when upgrading in a container environment.
cp makedev /etc/apt/preferences.d/makedev
cp locale.conf /etc/locale.conf
cp locale /etc/default/locale
#cp hosts /etc/hosts.lx

# make sure we get fresh ssh keys on first boot
rm -fv /etc/ssh/ssh_host_*_key*
cp rc.keys.ssh /etc/init.d/keys.ssh
chmod +x /etc/init.d/keys.ssh
update-rc.d keys.ssh defaults

#
#mv /usr/share/dbus-1/system-services/org.freedesktop.login1.service{,~}

# add dtrace tools
curl -sSLO https://mirrors.omnios.org/lx/dtracetools-lx_1.0_amd64.deb
dpkg -i dtracetools-lx_1.0_amd64.deb
rm dtracetools-lx_1.0_amd64.deb

# some smf helper folders
mkdir -p /var/svc /var/db

# remove .dockerenv file because lx is not a docker
rm /.dockerenv
