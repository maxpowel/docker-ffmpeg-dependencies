FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ENV NASM_VERSION 2.16.01
ENV FDK_AAC_VERSION 2.0.2
ENV X264_VERSION stable
ENV X265_VERSION 3.5

RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    cmake \
    autoconf \
    libtool

## NASM ##
RUN wget http://www.nasm.us/pub/nasm/releasebuilds/${NASM_VERSION}/nasm-${NASM_VERSION}.tar.gz && \
    tar -xf nasm-${NASM_VERSION}.tar.gz && \
    rm nasm-${NASM_VERSION}.tar.gz && \
    cd nasm-${NASM_VERSION} && \
    ./configure && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    cd .. && rm -rf nasm-${NASM_VERSION}

RUN wget https://github.com/mstorsjo/fdk-aac/archive/refs/tags/v${FDK_AAC_VERSION}.tar.gz && \
    tar -xf v${FDK_AAC_VERSION}.tar.gz && \
    rm v${FDK_AAC_VERSION}.tar.gz && \
    cd fdk-aac-${FDK_AAC_VERSION} && \
    autoreconf -vis && \
    ./configure --enable-shared && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    cd .. && rm -rf fdk-aac-${FDK_AAC_VERSION}

RUN wget https://code.videolan.org/videolan/x264/-/archive/${X264_VERSION}/x264-${X264_VERSION}.tar.gz && \
    tar -xf x264-${X264_VERSION}.tar.gz && \
    rm x264-${X264_VERSION}.tar.gz && \
    cd x264-${X264_VERSION} && \
    ./configure --enable-shared && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    cd .. && rm -rf x264-${X264_VERSION}


RUN wget https://bitbucket.org/multicoreware/x265_git/downloads/x265_${X265_VERSION}.tar.gz && \
    tar -xf x265_${X265_VERSION}.tar.gz && \ 
    rm x265_${X265_VERSION}.tar.gz && \ 
    cd x265_${X265_VERSION}/build/linux && \
    cmake -G "Unix Makefiles" ../../source && cmake ../../source -DENABLE_AGGRESSIVE_CHECKS=ON -DHIGH_BIT_DEPTH=ON -DENABLE_HDR10_PLUS=ON -DEXPORT_C_API=OFF -DENABLE_CLI=OFF && \
    make -j$(nproc) && \
    make -j$(nproc) install && \
    cd ../../../ && rm -rf x265_${X265_VERSION}

# Other nginx dependencies. I put them here to avoid recompile everything when adding a new library
RUN apt install -y  \
    yasm \
    libnuma1 \
    libnuma-dev \
    zlib1g-dev \
    pkgconf \
    libass-dev \
    libfreetype6-dev \
    libsdl2-dev \
    libtheora-dev \
    libtool \
    libva-dev \
    libvpx-dev \
    libvdpau-dev \
    libvorbis-dev \
    libmp3lame-dev \
    libxcb1-dev \
    libxcb-shm0-dev \
    libxcb-xfixes0-dev \
    asciidoc