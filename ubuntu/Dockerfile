ARG UBUNTU_RELEASE
FROM ubuntu:${UBUNTU_RELEASE}
COPY helpers /helpers
ARG UBUNTU_RELEASE=${UBUNTU_RELEASE}
RUN apt-get update && apt-get install -y systemd systemd-sysv systemd-timesyncd libnss-systemd libpam-systemd libsystemd0 networkd-dispatcher
RUN cd /helpers && sh build.sh && cd / && rm -rf helpers
