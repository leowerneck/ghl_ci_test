FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV VIRTUAL_ENV=/opt/et-python
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ARG ET_BUILD_JOBS=2

RUN apt-get update \
    && apt-get install -y --fix-missing \
        cmake \
        curl \
        g++ \
        gcc \
        gfortran \
        git \
        libfftw3-dev \
        libgit2-dev \
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
        python3-venv \
        rsync \
        subversion \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv "${VIRTUAL_ENV}" \
    && "${VIRTUAL_ENV}/bin/python" -m pip install --upgrade pip setuptools wheel \
    && "${VIRTUAL_ENV}/bin/pip" install --no-cache-dir \
        bokeh \
        jinja2 \
        matplotlib \
        numpy \
        pygit2 \
        requests

WORKDIR /opt/et-build

COPY GetComponents download_precompile_thornlist.sh gcc.cfg ./

RUN chmod +x GetComponents download_precompile_thornlist.sh \
    && ./download_precompile_thornlist.sh et-gcc \
    && cd et-gcc \
    && ./simfactory/bin/sim setup-silent \
    && ./simfactory/bin/sim build -j"${ET_BUILD_JOBS}" \
        --thornlist=thornlists/precompile.th \
        --optionlist=../gcc.cfg \
    && rm -f exe/cactus_sim


CMD ["bash"]
