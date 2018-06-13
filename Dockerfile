FROM buildpack-deps:stretch-scm as build
ARG VERSION=1.0.5
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        clang \
        libpcap-dev \
    && \
    git clone https://github.com/robertdavidgraham/masscan.git --branch ${VERSION} && \
    cd masscan && \
    make -j

FROM debian:stretch-slim
ARG VERSION=1.0.5
LABEL MASSCAN_VERSION=${VERSION}
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y libpcap0.8 && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/*
COPY --from=build /masscan/bin/masscan /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/masscan"]
