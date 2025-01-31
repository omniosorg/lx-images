ARG UBUNTU_RELEASE
FROM ubuntu:${UBUNTU_RELEASE}
COPY helpers /helpers
ARG UBUNTU_RELEASE=${UBUNTU_RELEASE}
RUN apt-get update && apt-get install -y systemd systemd-sysv systemd-timesyncd libnss-systemd libpam-systemd libsystemd0 networkd-dispatcher
RUN chmod 0 /bin/systemctl;cd /helpers; sh build.sh; cd /; rm -rf helpers;chmod 755 /bin/systemctl
