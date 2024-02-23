FROM docker.io/library/ubuntu:22.04 AS base

# Replace sh with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

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
# RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/charmbracelet/vhs/releases/latest | \
#     jq -r '.assets[] | select(.name| test(".*.amd64.deb$")).browser_download_url') \
#     && wget "${DOWNLOAD_URL}" -O package.deb \
#     && dpkg -i package.deb \
#     && rm package.deb \
#     && wget https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 -O /tmp/ttyd && \
#     install -c -m 0755 /tmp/ttyd /usr/bin/ttyd

# Install Mods
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/charmbracelet/mods/releases/latest | \
    jq -r '.assets[] | select(.name| test(".*.amd64.deb$")).browser_download_url') \
    && wget "${DOWNLOAD_URL}" -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb

# Install Glow
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/charmbracelet/glow/releases/latest | \
    jq -r '.assets[] | select(.name| test(".*.amd64.deb$")).browser_download_url') \
    && wget "${DOWNLOAD_URL}" -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb

# Install Skate
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/charmbracelet/skate/releases/latest | \
    jq -r '.assets[] | select(.name| test(".*.amd64.deb$")).browser_download_url') \
    && wget "${DOWNLOAD_URL}" -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb

# Install Gum
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/charmbracelet/gum/releases/latest | \
    jq -r '.assets[] | select(.name| test(".*.amd64.deb$")).browser_download_url') \
    && wget "${DOWNLOAD_URL}" -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb

# Install Github CLI
RUN DOWNLOAD_URL=$(curl -s https://api.github.com/repos/cli/cli/releases/latest | \
    jq -r '.assets[] | select(.name| test(".*_amd64.deb$")).browser_download_url') \
    && wget "${DOWNLOAD_URL}" -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb

#### Node ####
# nvm environment variables
RUN mkdir /usr/local/nvm
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 20.9.0

# NVM
#RUN touch ~/.bashrc && chmod +x ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
RUN source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default 

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Enable Corepack for Nodejs (needed for Yarn)
RUN corepack enable

# Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL='/usr' sh

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscli.zip" \
    && unzip awscli.zip \
    && ./aws/install \
    && rm awscli.zip \
    && rm -rf aws/

# Aliases
RUN echo "alias ll='ls -alF'" >> /etc/profile

# Install RVM, Ruby, and set default version
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm install 3.2.2" 
RUN /bin/bash -l -c "rvm use 3.2.2 --default"

# Install system-wide gems
RUN /bin/bash -l -c "gem install bundler ruby-openai"

# Install Windmill CLI
RUN deno install -A --root /usr/local https://deno.land/x/wmill/main.ts

# Install Warp Terminal
RUN wget https://releases.warp.dev/stable/v0.2024.02.20.08.01.stable_01/warp-terminal_0.2024.02.20.08.01.stable.01_amd64.deb -O package.deb \
    && dpkg -i package.deb \
    && rm package.deb

# Starship Shell Prompt
#RUN curl -Lo /tmp/starship.tar.gz "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz" && \
#  tar -xzf /tmp/starship.tar.gz -C /tmp && \
#  install -c -m 0755 /tmp/starship /usr/bin && \
#  echo 'eval "$(starship init bash)"' >> /etc/bashrc
