# https://github.com/dxatscale/sfpowerscripts/blob/main/dockerfiles/sfpowerscripts.Dockerfile

FROM  heroku/heroku:20.v77

ARG PMD_VERSION=${PMD_VERSION:-6.39.0}
ARG SFPOWERSCRIPTS_VERSION=alpha

# Create symbolic link from sh to bash
RUN ln -sf bash /bin/sh

# Install Common packages
RUN apt-get update && \
    apt-get install -qq \
        curl \
        sudo \
        jq \
        zip \
        unzip \
	      make \
        g++ \
        wget \
        gnupg \
	      libxkbcommon-x11-0 \
        libdigest-sha-perl \
        libxshmfence-dev \
  &&   apt-get autoremove --assume-yes \
  && apt-get clean --assume-yes \
  && rm -rf /var/lib/apt/lists/*

# Install NODE 16
RUN echo 'a0f23911d5d9c371e95ad19e4e538d19bffc0965700f187840eb39a91b0c3fb0  ./nodejs.tar.gz' > node-file-lock.sha \
  && curl -s -o nodejs.tar.gz https://nodejs.org/dist/v16.13.2/node-v16.13.2-linux-x64.tar.gz \
  && shasum --check node-file-lock.sha
RUN mkdir /usr/local/lib/nodejs \
  && tar xf nodejs.tar.gz -C /usr/local/lib/nodejs/ --strip-components 1 \
  && rm nodejs.tar.gz node-file-lock.sha
ENV PATH=/usr/local/lib/nodejs/bin:$PATH


# Install OpenJDK-11
RUN apt-get update && apt-get install --assume-yes openjdk-11-jdk-headless\
     && apt-get autoremove --assume-yes \
     && apt-get clean --assume-yes \
     && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME


# Set XDG environment variables explicitly so that GitHub Actions does not apply
# default paths that do not point to the plugins directory
# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
ENV XDG_DATA_HOME=/sfdx_plugins/.local/share
ENV XDG_CONFIG_HOME=/sfdx_plugins/.config
ENV XDG_CACHE_HOME=/sfdx_plugins/.cache



# Install Yarn
RUN npm install --global yarn

# Install sfdx-cli
RUN yarn global add sfdx-cli
RUN sfdx --version

# Install PMD
RUN mkdir -p $HOME/sfpowerkit
RUN cd $HOME/sfpowerkit \
      && wget -nc -O pmd.zip https://github.com/pmd/pmd/releases/download/pmd_releases/${PMD_VERSION}/pmd-bin-${PMD_VERSION}.zip \
      && unzip pmd.zip \
      && rm -f pmd.zip

# Install sfdx plugins
RUN echo "y" | sfdx plugins:install sfpowerkit
RUN echo 'y' | sfdx plugins:install sfdx-essentials
RUN echo "y" | sfdx plugins:install sfdx-git-delta

RUN sfdx plugins
