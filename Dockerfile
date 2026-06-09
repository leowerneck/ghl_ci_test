FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/intel/oneapi/compiler/latest/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/intel/oneapi/compiler/latest/lib:${LD_LIBRARY_PATH}"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ET_BUILD_JOBS=2

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        cmake \
        curl \
        g++ \
        gcc \
        gfortran \
        git \
        libfftw3-dev \
        libgsl-dev \
        libhdf5-dev \
        libhdf5-openmpi-dev \
        libhwloc-dev \
        libjpeg-dev \
        liblapack-dev \
        libopenmpi-dev \
        libpapi-dev \
        libssl-dev \
        libudev-dev \
        libyaml-cpp-dev \
        make \
        numactl \
        patch \
        perl \
        pkg-config \
        python-is-python3 \
        python3 \
        python3-pip \
        rsync \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo '. /opt/intel/oneapi/setvars.sh --force >/dev/null 2>&1' \
    > /etc/profile.d/oneapi.sh

WORKDIR /opt/et-build

COPY GetComponents download_precompile_thornlist.sh gcc.cfg ./

RUN chmod +x GetComponents download_precompile_thornlist.sh \
    && ./download_precompile_thornlist.sh et-gcc \
    && cd et-gcc \
    && ./simfactory/bin/sim setup-silent \
    && ./simfactory/bin/sim build -j"${ET_BUILD_JOBS}" \
        --thornlist=thornlists/precompile.th \
        --optionlist=../gcc.cfg

CMD ["bash"]
