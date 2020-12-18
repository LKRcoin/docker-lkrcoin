# Build stage for BerkeleyDB
FROM debian:jessie as berkeleydb

ENV BERKELEYDB_VERSION=db-4.8.30.NC
ENV BERKELEYDB_PREFIX=/opt/berkleydb

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

RUN apt-get update  \
    && apt-get install -y git wget build-essential automake autoconf\
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN wget -q https://download.oracle.com/berkeley-db/${BERKELEYDB_VERSION}.tar.gz
RUN tar -xzf *.tar.gz
RUN sed s/__atomic_compare_exchange/__atomic_compare_exchange_db/g -i ${BERKELEYDB_VERSION}/dbinc/atomic.h
RUN mkdir -p ${BERKELEYDB_PREFIX}

WORKDIR /${BERKELEYDB_VERSION}/build_unix

RUN ../dist/configure --enable-cxx --disable-shared --with-pic --prefix=${BERKELEYDB_PREFIX}
RUN make -j4
RUN make install
RUN rm -rf ${BERKELEYDB_PREFIX}/docs

# Build stage for lkrcoin
FROM debian:jessie as lkrcoin-build

COPY --from=berkeleydb /opt /opt

# ./configure can't find berkley db unless we do this
RUN ln -s /opt/berkleydb /usr/include/db4.8 \
    && ln -s /opt/berkleydb/include/* /usr/include  \
    && ln -s /opt/berkleydb/lib/* /usr/lib

RUN apt-get update  \
    && apt-get install -y git autoconf \
    build-essential pkg-config  libtool\
    automake autotools-dev \
    libdb++-dev libminiupnpc-dev libssl-dev libevent-dev bsdmainutils \
    libboost-dev libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

ENV LKRCOIN_PREFIX=/opt/lkrcoin
ENV MAKE_JOBS=1

WORKDIR ${LKRCOIN_PREFIX}

RUN git clone https://github.com/LKRcoin/lkrcoin.git \
    && cd lkrcoin \
    && cd src && mkdir -p obj/zerocoin && chmod a+x leveldb/build_detect_platform \
    && make -j$MAKE_JOBS -f makefile.unix \
    && cp LKRcoind /usr/bin/LKRcoind && chmod a+x /usr/bin/LKRcoind

RUN groupadd -r lkrcoin && useradd -r -m -g lkrcoin lkrcoin

# create data directory
ENV LKRCOIN_DATA /data

RUN mkdir "$LKRCOIN_DATA" \
    && chown -R lkrcoin:lkrcoin "$LKRCOIN_DATA" \
    && ln -sfn "$LKRCOIN_DATA" /home/lkrcoin/.LKRcoin \
    && chown -h lkrcoin:lkrcoin /home/lkrcoin/.LKRcoin
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

USER lkrcoin

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 34957 34958

CMD ["LKRcoind"]
