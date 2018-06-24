# ==================================================================================================
#
# Docker gitbook helper image
#
# Provide gitbook commands in a docker image to build and deploy your docs
#
# ==================================================================================================

# Base image, default node image
FROM node:slim

# Update locale to support unicode
ENV LANG C.UTF-8

# Environment configuration
ENV GITBOOK_VERSION="3.2.3"

USER root

# Install gitbook and lftp
RUN npm install --global gitbook-cli \
	&& gitbook fetch ${GITBOOK_VERSION} \
	&& npm cache clear --force \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y git build-essential python3-pip lftp calibre \
	&& pip3 install --pre Pygments pygments-lexer-solidity pygments-markdown-lexer \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/*

# Current directory configuration
WORKDIR /gitbook

# Volume for gitbook operations
VOLUME /gitbook

# Ports for serve command
EXPOSE 4000 35729

# Default cmd is version display
CMD /usr/local/bin/gitbook -V
