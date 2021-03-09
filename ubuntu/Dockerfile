ARG UBUNTU_RELEASE
FROM ubuntu:${UBUNTU_RELEASE}
COPY helpers /helpers
ARG UBUNTU_RELEASE=${UBUNTU_RELEASE}
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
