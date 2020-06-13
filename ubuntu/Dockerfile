ARG release
FROM ubuntu:${release}
ENV UBUNTU ${release}
COPY helpers /helpers
RUN cd /helpers; sh build.sh; cd /; rm -rf helpers
