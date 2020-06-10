#!/bin/sh
set -e
set -x
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq apt-utils
yes | unminimize
apt-get install -yq \
    systemd-sysv \
    iproute2 \
    curl \
    lsb-release \
    less \
    joe \
    net-tools
apt-get -qq clean
apt-get -qq autoremove 

# disable services we do not need
systemctl disable systemd-resolved fstrim.timer fstrim
if [ $UBUNTU = 20.04 ]; then
    systemctl disable e2scrub_all e2scrub_all.timer
fi

# disable systemd faeatures not present in lx (namely cgroup support)
for S in systemd-hostnamed systemd-localed systemd-timedated systemd-logind systemd-initctl  systemd-journald; do
  O=/etc/systemd/system/${S}.service.d
  mkdir -p $O
  cp override.conf ${O}/override.conf
done
 
# Prevents apt-get upgrade issue when upgrading in a container environment.
# Similar to https://bugs.launchpad.net/ubuntu/+source/makedev/+bug/1675163
cp makedev /etc/apt/preferences.d/makedev
cp locale.conf /etc/locale.conf
cp locale /etc/default/locale

# Remove the divert that disables services
rm -f /sbin/initctl
dpkg-divert --local --rename --remove /sbin/initctl

# add dtrace tools
curl -sSLO https://us-east.manta.joyent.com/joyentsoln/public/images/lx-brand/devel/packages/dtracetools-lx_1.0_amd64.deb
dpkg -i dtracetools-lx_1.0_amd64.deb
rm dtracetools-lx_1.0_amd64.deb

# some smf helper folders
mkdir -p /var/svc /var/db