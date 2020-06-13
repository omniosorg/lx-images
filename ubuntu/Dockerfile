ARG UBUNTU_RELEASE
FROM ubuntu:${UBUNTU_RELEASE}
ENV UBUNTU_RELEASE ${UBUNTU_RELEASE}
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
