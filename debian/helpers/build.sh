#!/bin/sh
set -ex
echo Installing Debian $DEBIAN_RELEASE
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -yq apt-utils
apt-get install -yq \
    systemd-sysv \
    vim \
    binutils \
    cron \
    dialog \
    openssh-server \
    sudo \
    iproute2 \
    curl \
    lsb-release \
    less \
    joe \
    man-db \
    net-tools \
    locales \
    rsync \
    tzdata \
    rsyslog \
    iputils-ping
apt-get -qq clean
rm -rf /var/lib/apt/lists/*
apt-get -qq autoremove

# disable services we do not need
systemctl disable \
    systemd-resolved fstrim.timer fstrim

# disable systemd features not present in lx (e.g. cgroup support)
for S in \
    systemd-hostnamed systemd-localed systemd-timedated \
    systemd-logind systemd-initctl systemd-journald
do
    O=/etc/systemd/system/${S}.service.d
    mkdir -p $O
    cp override.conf ${O}/override.conf
done

# credentials & ambient capabilities are not present in lx
for S in \
    systemd-journald systemd-sysusers \
    systemd-tmpfiles-setup systemd-tmpfiles-setup-dev \
    systemd-tmpfiles-setup-dev-early systemd-tmpfiles-clean
do
    O=/etc/systemd/system/${S}.service.d
    mkdir -p $O
    cp no-creds.conf ${O}/no-creds.conf
done
mkdir -p /etc/systemd/system/dbus.service.d
cp no-ambient-caps.conf /etc/systemd/system/dbus.service.d/no-ambient-caps.conf

# user@ fails on releases before r151060
mkdir -p /etc/systemd/system/user@.service.d
cp no-delegate-subgroup.conf /etc/systemd/system/user@.service.d/no-delegate-subgroup.conf

# units that fail in lx
systemctl mask console-getty.service tmp.mount run-lock.mount \
    e2scrub_reap.service e2scrub_all.service e2scrub_all.timer

# Prevents apt-get upgrade issue when upgrading in a container environment.
cp makedev /etc/apt/preferences.d/makedev
cp locale.conf /etc/locale.conf
cp locale /etc/default/locale
cp hosts /etc/hosts.lx

# Generate missing locales
locale-gen

# make sure we get fresh ssh keys on first boot
/bin/rm -f -v /etc/ssh/ssh_host_*_key*
cp regenerate_ssh_host_keys.service /etc/systemd/system
systemctl enable regenerate_ssh_host_keys

# hostfile fix
cp create_hosts_file.service /etc/systemd/system
systemctl enable create_hosts_file.service

# add dtrace tools
curl -sSLO https://mirrors.omnios.org/lx/dtracetools-lx_1.0_amd64.deb
dpkg -i dtracetools-lx_1.0_amd64.deb
rm dtracetools-lx_1.0_amd64.deb

# some smf helper folders
mkdir -p /var/svc /var/db

# remove .dockerenv file because lx is not a docker
rm -f /.dockerenv
