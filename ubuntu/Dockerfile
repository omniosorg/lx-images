ARG release
FROM ubuntu:${release}
COPY helpers /helpers
RUN cd /helpers; UBUNTU=${release} sh build.sh; cd /; rm -rf helpers