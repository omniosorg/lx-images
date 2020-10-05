ARG DEVUAN_RELEASE
FROM lpenz/devuan-${DEVUAN_RELEASE}-amd64:latest
ARG DEVUAN_RELEASE
ENV DEVUAN_RELEASE ${DEVUAN_RELEASE}
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
