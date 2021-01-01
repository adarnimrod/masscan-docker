FROM buildpack-deps:stretch-scm as build
ARG VERSION=1.0.5
ENV DEBIAN_FRONTEND noninteractive
# hadolint ignore=DL3008,DL3015
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        clang \
        libpcap-dev \
    && \
    git clone https://github.com/robertdavidgraham/masscan.git --branch ${VERSION} && \
    make -jC masscan

FROM debian:stretch-slim
ARG VERSION=1.0.5
LABEL MASSCAN_VERSION=${VERSION}
# hadolint ignore=DL3008
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libpcap0.8 && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* /var/cache/apt/archives/*
COPY --from=build /masscan/bin/masscan /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/masscan"]
