ARG CENTOS_RELEASE
FROM centos:${CENTOS_RELEASE}
COPY helpers /helpers
ARG CENTOS_RELEASE=${CENTOS_RELEASE}
RUN chmod 0 /bin/systemctl;cd /helpers; sh build.sh; cd /; rm -rf helpers;chmod 755 /bin/systemctl
