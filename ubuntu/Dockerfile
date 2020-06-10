ARG release
FROM ubuntu:${release}
COPY helpers /helpers
RUN cd /helpers; UBUNTU=${release} build.sh; cd /; rm -rf helpers