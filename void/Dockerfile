FROM ghcr.io/void-linux/void-glibc-full
COPY helpers /helpers
RUN cd /helpers && sh build.sh && cd / && rm -rf helpers
