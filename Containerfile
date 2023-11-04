FROM docker.io/library/ubuntu:22.04 as portable-zoom

ENV DEBIAN_FRONTEND=noninteractive

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

# Install VHS
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/charmbracelet/vhs/releases/latest | \
    jq -r '.assets[] | select(.name| test(".*.amd64.deb$")).browser_download_url') \
    && wget "${DOWNLOAD_URL}" -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb \
    && wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /tmp/ttyd && \
    install -c -m 0755 /tmp/ttyd /usr/bin/ttyd