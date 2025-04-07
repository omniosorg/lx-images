ARG DEBIAN_RELEASE
FROM debian:${DEBIAN_RELEASE}
ARG DEBIAN_RELEASE
ENV DEBIAN_RELEASE ${DEBIAN_RELEASE}
COPY helpers /helpers
RUN cd /helpers && sh build.sh && cd / && rm -rf helpers
