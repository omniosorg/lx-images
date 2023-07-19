ARG ROCKY_RELEASE
FROM rockylinux:${ROCKY_RELEASE}
COPY helpers /helpers
ARG ROCKY_RELEASE=${ROCKY_RELEASE}
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
