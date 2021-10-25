FROM ghcr.io/alice-alias/waifu2x-docker/waifu2x-docker

RUN apt-get update && apt-get install -y \
    curl \
 && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update && apt-get install -y \
    nodejs \
 && rm -rf /var/lib/apt/lists/*
