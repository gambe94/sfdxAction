# The tests done in tests/test_foo.py are for checking this image

FROM ubuntu:18.04

ENV SFDX_AUTOUPDATE_DISABLE=true

RUN apt-get update && apt-get install -y \
  wget \
  xz-utils \
  ca-certificates \
  jq \
  bc \
  git \
  python \
  xmlstarlet \
  sudo \
  curl \
  && rm -rf /var/lib/apt/lists/*

#nodeJS last stable version
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
RUN apt-get install -y nodejs

RUN npm install -g npm@8.13.2
#Install sfdx latest version with npm
RUN npm install sfdx-cli --location=global
RUN sfdx --version



RUN echo "y" | sfdx plugins:install sfpowerkit
#Add sfdx essentials
RUN echo 'y' | sfdx plugins:install sfdx-essentials
#ADD sfdx-git-delta
RUN echo "y" | sfdx plugins:install sfdx-git-delta

RUN sfdx plugins
