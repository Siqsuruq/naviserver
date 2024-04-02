# Stage 1: Build Stage
FROM ubuntu:jammy AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG TCL_BUILD_HOME=/opt/tcl_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk

# Install build dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales unzip tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev automake nsf nsf-shells fortune fortunes imagemagick file git gcc zip libcurl4-openssl-dev wget iputils-ping brotli libxml2-utils curl ca-certificates gnupg2 lsb-release xz-utils \
	&& locale-gen C.UTF-8 \
	&& update-locale LANG=C.UTF-8 \
	&& apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && git config --global http.sslverify false \
    && git config --global https.sslverify false \
    && git clone https://github.com/flightaware/Pgtcl.git ${TCL_BUILD_HOME}/src/pgtcl \
    && cd ${TCL_BUILD_HOME}/src/pgtcl \
    && autoreconf \
    && ./configure --with-postgres-include=$PG_INCL --with-postgres-lib=$PG_LIB && make \
    && git clone https://github.com/flightaware/tclcurl-fa.git ${TCL_BUILD_HOME}/src/tclcurl \
    && cd ${TCL_BUILD_HOME}/src/tclcurl \
    && ./configure --enable-threads && make \
	&& git clone https://github.com/aschoepe/tzint.git ${TCL_BUILD_HOME}/src/tzint \
 	&& cd ${TCL_BUILD_HOME}/src/tzint \
	&& ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
	&& ./configure && make \
	&& wget --no-check-certificate https://core.tcl-lang.org/tclvfs/zip/72e30db4a7/tclvfs-72e30db4a7.zip -P ${TCL_BUILD_HOME}/src/vfs/ \
	&& unzip ${TCL_BUILD_HOME}/src/vfs/tclvfs-72e30db4a7.zip -d ${TCL_BUILD_HOME}/src/vfs/ \
	&& mv ${TCL_BUILD_HOME}/src/vfs/tclvfs-72e30db4a7/* ${TCL_BUILD_HOME}/src/vfs/ \
	&& wget --no-check-certificate https://core.tcl-lang.org/tclconfig/zip/2a8174cc0c/TEA+%28tclconfig%29+Source+Code-2a8174cc0c.zip -P ${TCL_BUILD_HOME}/src/vfs/ -O ${TCL_BUILD_HOME}/src/vfs/tclconfig.zip \
	&& unzip ${TCL_BUILD_HOME}/src/vfs/tclconfig.zip -d ${TCL_BUILD_HOME}/src/vfs/tclconfig \
	&& mv ${TCL_BUILD_HOME}/src/vfs/tclconfig/TEA*/* ${TCL_BUILD_HOME}/src/vfs/tclconfig/ \
	&& cd ${TCL_BUILD_HOME}/src/vfs \
	&& autoconf && ./configure && make \
	&& git clone https://github.com/aschoepe/ooxml.git ${TCL_BUILD_HOME}/src/ooxml \
 	&& cd ${TCL_BUILD_HOME}/src/ooxml \
	&& ./configure && make \
	&& git clone https://github.com/Siqsuruq/money-tcl-package.git ${TCL_BUILD_HOME}/src/money \
	&& git clone https://github.com/Siqsuruq/mimext.git ${TCL_BUILD_HOME}/src/mimext \
	&& git clone https://github.com/Siqsuruq/hrfilesize.git ${TCL_BUILD_HOME}/src/hrfilesize


# Stage 2: Final Image
FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
ARG TCL_BUILD_HOME=/opt/tcl_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk
ARG WORKDIR=/opt/tcltk
ENV LC_ALL=C.UTF-8

# Copy built Tcl packages from the builder stage
COPY --from=builder ${TCL_BUILD_HOME} ${TCL_BUILD_HOME}

# Install runtime dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev nsf nsf-shells fortune fortunes imagemagick file zip libcurl4-openssl-dev brotli libxml2-utils gnupg2 make \
	&& locale-gen C.UTF-8 \
	&& update-locale LANG=C.UTF-8 \
	&& apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* 

# Run make install for each package
RUN cd ${TCL_BUILD_HOME}/src/pgtcl && make install \
    && cd ${TCL_BUILD_HOME}/src/tclcurl && make install \
	&& ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
	&& cd ${TCL_BUILD_HOME}/src/tzint && make install \
	&& cd ${TCL_BUILD_HOME}/src/vfs && make install \
	&& cd ${TCL_BUILD_HOME}/src/ooxml && make install \
	&& cp -r ${TCL_BUILD_HOME}/src/money/money $TCL_LIB/ \
	&& cp -r ${TCL_BUILD_HOME}/src/mimext $TCL_LIB/ \
	&& cp -r ${TCL_BUILD_HOME}/src/hrfilesize $TCL_LIB/ 
	

# Cleanup
RUN rm -rf ${TCL_BUILD_HOME}/src

# Set working directory
WORKDIR ${WORKDIR}

# Entrypoint
ENTRYPOINT ["tclsh"]
