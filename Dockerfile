# Minimal Docker image for MaxBin using Alpine base
FROM alpine:latest

# install MaxBin
RUN apk update && \
    apk add --no-cache bash curl g++ make musl-dev perl perl-dev zlib-dev && \
    wget -qO- "https://sourceforge.net/projects/maxbin/files/MaxBin-2.2.7.tar.gz/download" | tar -zx && \
    cd MaxBin-*/src && \
    make && \
    cd .. && \
    PERL_MM_USE_DEFAULT=1 ./autobuild_auxiliary && \
    cd .. && \
    rm -rf MaxBin-*
