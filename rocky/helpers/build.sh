#!/bin/sh
set -ex
echo Installing RockyLinux $ROCKY_RELEASE
dnf update -y
dnf install -y --allowerasing \
    cronie \
    systemd-sysv \
    vim \
    binutils \
    dialog \
    diffutils \
    iputils \
    langpacks-en \
    glibc-langpack-en \
    openssh-server \
    openssh-clients \
    passwd \
    procps-ng \
    rsyslog \
    sudo \
    curl \
    less \
    man-db \
    bind-utils \
    net-tools


# disable services we do not need
systemctl mask systemd-remount-fs.service
systemctl mask systemd-resolved fstrim.timer fstrim
systemctl mask e2scrub_reap e2scrub_all e2scrub_all.timer

# disable systemd features not present in lx (e.g. cgroup support)
for S in \
    systemd-hostnamed systemd-localed systemd-timedated systemd-logind \
    systemd-initctl systemd-journald
do
    O=/etc/systemd/system/${S}.service.d
    mkdir -p $O
    cp override.conf ${O}/override.conf
done

# This service doesn't exist yet but systemd will happily create the /dev/null
# mapping for it. It comes in with nfs-common and fails because lx doesn't know
# about rpc_pipefs.  NFSv4 still seems to mount without this service and
# lx_lockd is still started. Let's hide it from the user so they see don't see
# unecessary failed services.
systemctl mask run-rpc_pipefs.mount

# lx hosts file
cp hosts /etc/hosts.lx

# make sure we get fresh ssh keys on first boot
# note that rocky uses the sshd-keygen@.service to regenerate missing keys
/bin/rm -f -v /etc/ssh/ssh_host_*_key*

# hostfile fix
cp create_hosts_file.service /etc/systemd/system
systemctl enable create_hosts_file.service

# remove .dockerenv file because lx is not a docker
cp remove_dockerenv_file.service /etc/systemd/system
systemctl enable remove_dockerenv_file.service

# some smf helper folders
mkdir -p /var/svc /var/db
