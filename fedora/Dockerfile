ARG FEDORA_RELEASE
FROM fedora:${FEDORA_RELEASE}
COPY helpers /helpers
ARG FEDORA_RELEASE=${FEDORA_RELEASE}
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
