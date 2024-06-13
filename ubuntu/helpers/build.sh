#!/bin/sh

set -ex
echo Installing Ubuntu $UBUNTU_RELEASE
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yq apt-utils
yes | unminimize
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
    iputils-ping \
    locales \
    rsync \
    rsyslog \
    tzdata
apt-get -qq clean
rm -rf /var/lib/apt/lists/*
apt-get -qq autoremove

# disable services we do not need
systemctl mask systemd-remount-fs.service
systemctl mask systemd-resolved fstrim.timer fstrim
if [ ${UBUNTU_RELEASE} = "20.04" -o ${UBUNTU_RELEASE} = "22.04" ]; then
    systemctl mask e2scrub_reap e2scrub_all e2scrub_all.timer
    # systemd does not seem to realize that /dev/null is NOT a terminal
    # under lx but when trying to chown it, it fails and thus the `User=`
    # directive does not work properly ... this little trick fixes the
    # behavior for the user@.service but obviously it has to be fixed in
    # lx :) ...
    touch /etc/systemd/null
    mkdir -p /etc/systemd/system/user@.service.d
    echo "[Service]\nStandardInput=file:/etc/systemd/null\n" \
        > /etc/systemd/system/user@.service.d/override.conf
fi

# disable systemd features not present in lx (e.g. cgroup support)
for S in \
    systemd-hostnamed systemd-localed systemd-timedated systemd-logind \
    systemd-initctl systemd-journald systemd-sysusers
do
    O=/etc/systemd/system/${S}.service.d
    mkdir -p $O
    if [ ${UBUNTU_RELEASE} = "22.04" ]; then
	cp override22.conf ${O}/override.conf
    else
	cp override.conf ${O}/override.conf
    fi
done

# This service doesn't exist yet but systemd will happily create the /dev/null
# mapping for it. It comes in with nfs-common and fails because lx doesn't know
# about rpc_pipefs.  NFSv4 still seems to mount without this service and
# lx_lockd is still started. Let's hide it from the user so they see don't see
# unecessary failed services.
systemctl mask run-rpc_pipefs.mount

# Prevents apt-get upgrade issue when upgrading in a container environment.
# Similar to https://bugs.launchpad.net/ubuntu/+source/makedev/+bug/1675163
cp makedev /etc/apt/preferences.d/makedev
cp locale.gen /etc/locale.gen
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

# remove .dockerenv file because lx is not a docker
cp remove_dockerenv_file.service /etc/systemd/system
systemctl enable remove_dockerenv_file.service

# Revert systemd's tcp wrapper for ssh. This really only applies to 24.04,
# but won't cause a failure on earlier versions.
systemctl disable ssh.socket
systemctl enable ssh.service

# Remove the divert that disables services
rm -f /sbin/initctl
dpkg-divert --local --rename --remove /sbin/initctl

# add dtrace tools
curl -sSLO https://mirrors.omnios.org/lx/dtracetools-lx_1.0_amd64.deb
dpkg -i dtracetools-lx_1.0_amd64.deb
rm dtracetools-lx_1.0_amd64.deb

# some smf helper folders
mkdir -p /var/svc /var/db
