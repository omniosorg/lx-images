ARG CENTOS_RELEASE
FROM centos:${CENTOS_RELEASE}
COPY helpers /helpers
ARG CENTOS_RELEASE=${CENTOS_RELEASE}
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
