# Minimal Docker image for MaxBin using Alpine base
FROM alpine:latest

# install MaxBin
RUN apk update && \
    apk add --no-cache bash curl g++ gcc make musl-dev perl perl-dev perl-libwww python3 unzip zlib-dev && \

    # install Bowtie2
    wget -qO- "https://github.com/BenLangmead/bowtie2/archive/refs/tags/v2.5.5.tar.gz" | tar -zx && \
    cd bowtie2-* && \
    make && \
    make install && \
    cd .. && \

    # install FragGeneScan
    wget -qO- "https://github.com/gaberoo/FragGeneScan/archive/refs/tags/v1.3.0.tar.gz" | tar -zx && \
    cd FragGeneScan-* && \
    make clean && \
    make CFLAGS="-Wno-error=implicit-function-declaration" fgs && \
    mv FragGeneScan run_FragGeneScan.pl /usr/local/bin/ && \
    cd .. && \

    # install HMMER
    wget -qO- "http://eddylab.org/software/hmmer/hmmer-3.4.tar.gz" | tar -zx && \
    cd hmmer-* && \
    ./configure && \
    make && \
    make install && \
    cd .. && \

    # install IDBA-UD
    wget -qO- "https://github.com/loneknightpy/idba/releases/download/1.1.3/idba-1.1.3.tar.gz" | tar -zx && \
    cd idba-* && \
    ./configure && \
    make && \
    make install && \
    rm -rf bin/*.o bin/Makefile* && \
    mv bin/* /usr/local/bin/ && \
    cd .. && \

    # install MaxBin
    wget -qO- "https://sourceforge.net/projects/maxbin/files/MaxBin-2.2.7.tar.gz/download" | tar -zx && \
    cd MaxBin-*/src && \
    make && \
    cd ../.. && \
    mv MaxBin-* /usr/local/bin/ && \
    for f in /usr/local/bin/MaxBin-*/*.pl ; do ln -s "$f" /usr/local/bin/$(basename "$f") ; done && \
    ln -s /usr/local/bin/MaxBin-*/src /usr/local/bin/src && \

    # clean up
    rm -rf /tmp/* bowtie2-* FragGeneScan-* hmmer-* idba-*
