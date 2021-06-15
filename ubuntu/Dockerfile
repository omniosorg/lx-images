ARG UBUNTU_RELEASE
FROM ubuntu:${UBUNTU_RELEASE}
COPY helpers /helpers
ARG UBUNTU_RELEASE=${UBUNTU_RELEASE}
RUN chmod 0 /bin/systemctl;cd /helpers; sh build.sh; cd /; rm -rf helpers;chmod 755 /bin/systemctl
