ARG ALMA_RELEASE
FROM almalinux:${ALMA_RELEASE}
COPY helpers /helpers
ARG ALMA_RELEASE=${ALMA_RELEASE}
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
