#!/bin/bash

# based on https://github.com/decred/dcrdocker/blob/master/Dockerfile-dcrd

set -euo pipefail

DEBIAN_FRONTEND=noninteractive
DECRED_VERSION=${DECRED_VERSION:-v1.2.0}
BUILD_DEPS=curl
USER=ubuntu

echo "Installing packer-staking (decred)"

adduser --disabled-password --gecos '' $USER

# Update base distro & install build tooling
apt-get update
apt-get install -qq -y $BUILD_DEPS

# Decred release url and files
DCR_RELEASE_URL="https://github.com/decred/decred-binaries/releases/download/$DECRED_VERSION"
DCR_MANIFEST_FILE="manifest-$DECRED_VERSION.txt"
DCR_RELEASE_NAME="decred-linux-amd64-$DECRED_VERSION"
DCR_RELEASE_FILE="$DCR_RELEASE_NAME.tar.gz"

# Import Decred gpg key
gpg --keyserver pgp.mit.edu --recv-keys 0x518A031D

# Download archives
cd /tmp
curl -SLO $DCR_RELEASE_URL/$DCR_RELEASE_FILE
curl -SLO $DCR_RELEASE_URL/$DCR_MANIFEST_FILE
curl -SLO $DCR_RELEASE_URL/$DCR_MANIFEST_FILE.asc

# Verify signature and hash
gpg --verify --trust-model=always $DCR_MANIFEST_FILE.asc
grep "$DCR_RELEASE_FILE" $DCR_MANIFEST_FILE | sha256sum -c -
rm -R ~/.gnupg

# Extract and install
tar xvzf $DCR_RELEASE_FILE
ls -la $DCR_RELEASE_FILE
mv $DCR_RELEASE_NAME/dcrd /usr/bin
mv $DCR_RELEASE_NAME/dcrwallet /usr/bin
mv $DCR_RELEASE_NAME/dcrctl /usr/bin
mkdir -p /home/$USER/.dcrd
chown -R $USER.$USER /home/$USER

# Cleanup
apt-get -qy remove $BUILD_DEPS
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
