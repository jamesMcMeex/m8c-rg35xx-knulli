FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Update GPG keys and install required packages
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get update && \
    apt-get install -y gnupg && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32 871920D1991BC93C && \
    apt-get update && \
    apt-get install -y \
    wget \
    tar \
    make \
    gcc \
    sed \
    crossbuild-essential-arm64 \
    ca-certificates \
    bc \
    libssl-dev \
    pkg-config \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Download and extract Linux kernel
RUN wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.170.tar.gz && \
    tar -xzf linux-4.9.170.tar.gz && \
    rm linux-4.9.170.tar.gz

# Download and prepare m8c
RUN wget https://github.com/laamaa/m8c/archive/refs/tags/v1.7.8.tar.gz \
    && tar -xzvf v1.7.8.tar.gz \
    && mv m8c-1.7.8 m8c \
    && rm v1.7.8.tar.gz

# Download Knulli Linux config file
RUN wget -O linux-sunxi64-legacy.config https://raw.githubusercontent.com/knulli-cfw/distribution/knulli-main/board/batocera/allwinner/h700/linux-sunxi64-legacy.config

# Download and extract Knulli ARM64 toolchain with retry
RUN wget -O aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz https://github.com/knulli-cfw/toolchains/releases/download/rg35xx-plush-sdk-20240421/aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz \
    && tar -xzvf aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz \
    && rm aarch64-buildroot-linux-gnu_sdk-buildroot.tar.gz

COPY build_script.sh /build/
RUN chmod +x /build/build_script.sh && dos2unix /build/build_script.sh

# Ensure the output directory exists
RUN mkdir -p /build/compiled/m8c

CMD ["/bin/bash", "/build/build_script.sh"]
