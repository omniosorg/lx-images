ARG DEVUAN_RELEASE
FROM dyne/devuan:${DEVUAN_RELEASE}
ARG DEVUAN_RELEASE
ENV DEVUAN_RELEASE ${DEVUAN_RELEASE}
COPY helpers /helpers
RUN cd /helpers && sh build.sh && cd / && rm -rf helpers
