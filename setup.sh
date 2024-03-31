#!/bin/bash

# Update the package repository and install necessary packages
apt-get update -y && apt-get install -y \
    apt-utils \
    gnupg \
    ca-certificates \
    gnupg \
    apt-transport-https \
    curl

# Update repository signing keys for Hyperledger and Sovrin
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9692C00E657DDE61 && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CE7709D068DB5E88

# Add repository sources
echo "deb https://hyperledger.jfrog.io/artifactory/indy focal stable"  >> /etc/apt/sources.list && \
printf '%s\n%s\n%s\n' 'Package: *' 'Pin: origin hyperledger.jfrog.io' 'Pin-Priority: 1001' >> /etc/apt/preferences  && \
echo "deb http://security.ubuntu.com/ubuntu bionic-security main"  >> /etc/apt/sources.list && \
echo "deb https://repo.sovrin.org/deb bionic master" >> /etc/apt/sources.list

# Install packages
apt-get update -y && apt-get install -y \
    rocksdb=5.8.8 \
    libgflags-dev \
    libsnappy-dev \
    zlib1g-dev \
    libbz2-dev \
    liblz4-dev \
    docker \
    docker-compose \
    libgflags-dev \
    python3-libnacl=1.6.1 \
    python3-sortedcontainers=1.5.7 \
    python3-ujson=1.33 \
    python3-pyzmq=22.3.0 \
    indy-plenum=1.13.1~rc4 \
    indy-node=1.13.2~rc6 \
    libssl1.0.0 \
    python3-pip \
    ursa=0.3.2-1 \
    && mv /usr/lib/ursa/* /usr/lib && rm -rf /usr/lib/ursa

# Install Indy Node and its dependencies
apt-get update -y && apt install -y \
    /indy-node_1.13.2_amd64.deb indy-plenum=1.13.1
curl -O https://hyperledger.jfrog.io/artifactory/indy/pool/focal/stable/i/indy-node/indy-node_1.13.2_amd64.deb

apt-get update -y && apt install -y \
    indy-node=1.13.2 \
    && mv /usr/lib/ursa/* /usr/lib && rm -rf /usr/lib/ursa

#Install testinfra
pip3 install testinfra
pip3 install scripts/performance


./v-network/manage build
