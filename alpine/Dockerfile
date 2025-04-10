ARG ALPINE_RELEASE
FROM alpine:${ALPINE_RELEASE}
COPY helpers /helpers
ARG ALPINE_RELEASE=${ALPINE_RELEASE}
RUN cd /helpers && sh build.sh && cd / && rm -rf helpers
