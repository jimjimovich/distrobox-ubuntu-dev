FROM docker.io/library/ubuntu:22.04 as portable-zoom

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="Ubuntu Dev Environment" \
      maintainer="jim@starryhope.com"

COPY ./extra-packages /extra-packages

RUN apt-get update &&   \ 
    apt-get upgrade -y &&  \
    DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        $(cat extra-packages | xargs) && \
    rm -rd /var/lib/apt/lists/*
