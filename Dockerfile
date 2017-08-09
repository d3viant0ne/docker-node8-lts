FROM ubuntu:xenial

MAINTAINER d3viant0ne <wiens.joshua@gmail.com>

# Setup Build ENV
# ...
ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 8.2.1
ENV NPM_VERSION=5

# ...
# Configure Install Environment
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# ...
# Run updates
RUN apt-get update --fix-missing

# Install dependencies
RUN apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    libssl-dev \
    curl \
    g++ \
    gcc \
    git \
    make \
    wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get -y autoclean

# Install Demo Certificates
# ...
COPY ./certs/chain.pem    /etc/ssl/certs/chain.pem
COPY ./certs/privkey.pem   /etc/ssl/private/privkey.pem
COPY ./certs/fullchain.pem    /etc/ssl/certs/fullchain.pem

# Setup Key Permissions
# ...
RUN chmod 600 /etc/ssl/private/privkey.pem

# Configure NVM Directory Permissions
# ...
RUN mkdir -p /usr/local/nvm
RUN chmod 775 /usr/local/nvm

# NodeJS Configuration
# ...
ENV NVM_DIR /usr/local/nvm

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# Set up PATH for Node & NVM
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# Install pm2
RUN npm i -g pm2

EXPOSE 4430

CMD [ "node" ]