#!/bin/sh
set -ex
echo Installing Centos $CENTOS_RELEASE
dnf update -y
dnf install -y \
    systemd-sysv \
    vim \
    binutils \
    dialog \
    openssh-server \
    openssh-clients \
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

# systemd does not seem to realize that /dev/null is NOT a terminal
# under lx but when trying to chown it, it fails and thus the `User=`
# directive does not work properly ... this little trick fixes the
# behavior for the user@.service but obviously it has to be fixed in
# lx :) ...
touch /etc/systemd/null
mkdir -p /etc/systemd/system/user@.service.d
echo "[Service]\nStandardInput=file:/etc/systemd/null\n" \
> /etc/systemd/system/user@.service.d/override.conf

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

cp locale.gen /etc/locale.gen
cp locale.conf /etc/locale.conf
cp locale /etc/default/locale
cp hosts /etc/hosts.lx

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

# some smf helper folders
mkdir -p /var/svc /var/db
