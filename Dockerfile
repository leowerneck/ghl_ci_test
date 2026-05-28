FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/intel/oneapi/compiler/latest/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/intel/oneapi/compiler/latest/lib:${LD_LIBRARY_PATH}"
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        wget \
    && wget -qO- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB \
        | gpg --dearmor -o /usr/share/keyrings/intel-oneapi-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/intel-oneapi-archive-keyring.gpg] https://apt.repos.intel.com/oneapi all main" \
        > /etc/apt/sources.list.d/oneAPI.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        clang \
        intel-oneapi-compiler-dpcpp-cpp \
        gcovr \
        libhdf5-serial-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN echo '. /opt/intel/oneapi/setvars.sh --force >/dev/null 2>&1' \
    > /etc/profile.d/oneapi.sh

CMD ["bash"]
