FROM alpine:3.24

RUN apk add --no-cache git \
    mercurial \
    mount \
    rsync \
    sudo \
    && mkdir -p /etc/slitaz

COPY tazlab tazlab-build /usr/bin
COPY tazlab.conf /etc/slitaz

ENV SLITAZ_HOME=/root/.slitaz
ENV ARCH=x86_64

WORKDIR /root

ENTRYPOINT ["/usr/bin/tazlab"]