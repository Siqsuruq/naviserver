# Base Alpine Image with Tcl and Tcllib
# Stage 1: Builder
FROM alpine:latest AS builder

ARG TCL_BUILD_HOME=/opt/tcl_build
ARG TCL_LIB=/usr/local/lib

# Install dependencies, download and install Tcl, and clean up in a single RUN command to reduce layers
RUN apk add --no-cache bash gcc musl-dev libpq-dev openssl openssl-dev build-base zlib-dev autoconf tar gzip git libpng-dev curl curl-dev \
    && wget https://sourceforge.net/projects/tcl/files/Tcl/8.6.16/tcl8616-src.zip -O tcl.zip \
    && mkdir -p ${TCL_BUILD_HOME}/tcl \
    && unzip tcl.zip -d ${TCL_BUILD_HOME}/tcl \
    && cd ${TCL_BUILD_HOME}/tcl/tcl8.6.16/unix \
    && ./configure --enable-64bit --enable-threads \
    && make \
    && make install \
	&& wget https://github.com/tcltk/tcllib/archive/refs/tags/tcllib-2-0.zip -O tcllib-2-0.zip \
    && mkdir -p ${TCL_BUILD_HOME}/tcllib \
    && unzip tcllib-2-0.zip -d ${TCL_BUILD_HOME}/tcllib \
    && cd ${TCL_BUILD_HOME}/tcllib/tcllib-tcllib-2-0/ \
    && ./configure \
	&& make install \
	&& wget tdom.org/index.html/zip/trunk/tdom-trunk.zip -O tdom-trunk.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tdom \
    && unzip tdom-trunk.zip -d ${TCL_BUILD_HOME}/tdom \
    && cd ${TCL_BUILD_HOME}/tdom/tdom-trunk/ \
	&& ./configure \
	&& make install \
	&& wget https://github.com/flightaware/Pgtcl/archive/refs/tags/v3.1.0.zip -O pgtcl.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/pgtcl \
    && unzip pgtcl.zip -d ${TCL_BUILD_HOME}/pgtcl \
    && cd ${TCL_BUILD_HOME}/pgtcl/Pgtcl-3.1.0/ \
	&& autoreconf \
    && ./configure && make \
	&& make install \
	&& wget https://github.com/flightaware/tclcurl-fa/archive/refs/tags/v7.22.1.zip -O v7.22.1.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tclcurl \
    && unzip v7.22.1.zip -d ${TCL_BUILD_HOME}/tclcurl \
    && cd ${TCL_BUILD_HOME}/tclcurl/tclcurl-fa-7.22.1/ \
    && ./configure --enable-64bit && make \
	&& make install \
	&& wget https://core.tcl-lang.org/tcltls/zip/e03e54ee87/tcltls-e03e54ee87.zip -O tcltls-1.8.0.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tcltls \
	&& unzip tcltls-1.8.0.zip -d ${TCL_BUILD_HOME}/tcltls \
    && cd ${TCL_BUILD_HOME}/tcltls/tcltls-e03e54ee87/ \
    && ./configure  --enable-64bit && make \
	&& make install-binaries install-libraries \
	&& wget https://github.com/nm-wu/nsf/archive/refs/tags/2.4.0.zip -O nsf.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/nsf \
    && unzip nsf.zip -d ${TCL_BUILD_HOME}/nsf \
    && cd ${TCL_BUILD_HOME}/nsf/nsf-2.4.0/ \
    && ./configure --enable-64bit --enable-threads && make \
	&& make install \
	&& git clone https://github.com/aschoepe/tzint.git ${TCL_BUILD_HOME}/src/tzint \
 	&& cd ${TCL_BUILD_HOME}/src/tzint \
	&& ./configure --enable-64bit && make \
	&& make install-binaries install-libraries \
	&& wget --no-check-certificate https://core.tcl-lang.org/tclvfs/zip/f082c47f9b/tclvfs-f082c47f9b.zip -O tclvfs-f082c47f9b.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/src/vfs/ \
	&& unzip tclvfs-f082c47f9b.zip -d ${TCL_BUILD_HOME}/src/vfs \
	&& mv ${TCL_BUILD_HOME}/src/vfs/tclvfs-f082c47f9b/* ${TCL_BUILD_HOME}/src/vfs/ \
	&& wget --no-check-certificate https://core.tcl-lang.org/tclconfig/zip/c34cded0a3/TEA+%28tclconfig%29+Source+Code-c34cded0a3.zip -P ${TCL_BUILD_HOME}/src/vfs/ -O ${TCL_BUILD_HOME}/src/vfs/tclconfig.zip \
	&& unzip ${TCL_BUILD_HOME}/src/vfs/tclconfig.zip -d ${TCL_BUILD_HOME}/src/vfs/tclconfig \
	&& mv ${TCL_BUILD_HOME}/src/vfs/tclconfig/TEA*/* ${TCL_BUILD_HOME}/src/vfs/tclconfig/ \
	&& cd ${TCL_BUILD_HOME}/src/vfs \
	&& ./configure && make && make install \
	&& wget --no-check-certificate https://fossil.sowaswie.de/ooxml/uv/ooxml1.9.zip -O ooxml1.9.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/src/ooxml/ \
	&& unzip ooxml1.9.zip -d ${TCL_BUILD_HOME}/src/ooxml \
	&& cp -r ${TCL_BUILD_HOME}/src/ooxml/ooxml1.9 $TCL_LIB/ \
	&& git clone https://github.com/Siqsuruq/money-tcl-package.git ${TCL_BUILD_HOME}/src/money \
	&& cp -r ${TCL_BUILD_HOME}/src/money/money $TCL_LIB/ \
	&& git clone https://github.com/Siqsuruq/mimext.git ${TCL_BUILD_HOME}/src/mimext \
	&& cp -r ${TCL_BUILD_HOME}/src/mimext $TCL_LIB/ \
	&& git clone https://github.com/Siqsuruq/hrfilesize.git ${TCL_BUILD_HOME}/src/hrfilesize \
	&& cp -r ${TCL_BUILD_HOME}/src/hrfilesize $TCL_LIB/ \
	&& wget https://github.com/Kazmirchuk/nats-tcl/archive/refs/tags/v3.0.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/nats \
	&& unzip v3.0.zip -d ${TCL_BUILD_HOME}/nats \
	&& cp -r ${TCL_BUILD_HOME}/nats/nats-tcl-3.0 $TCL_LIB/ \
    && cd / \
    && rm -rf ${TCL_BUILD_HOME} tcl.zip /var/cache/apk/*

# Stage 2: Final Image
FROM alpine:latest

# Declare BUILD_DATE as an argument
ARG BUILD_DATE

# Metadata using OCI Image Format Specification annotations
LABEL org.opencontainers.image.title="Alpine Tcl batteries-included Image"
LABEL org.opencontainers.image.description="A custom Docker image with Alpine, Tcl, Tcllib and some Tcl packages."
LABEL org.opencontainers.image.version="1.2"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.authors="admin@cloudz.cv"
LABEL org.opencontainers.image.vendor="Cloudz"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/Siqsuruq/naviserver/tree/main/AlpineTclBatteriesIncluded"
LABEL org.opencontainers.image.documentation="https://github.com/Siqsuruq/naviserver/tree/main/AlpineTclBatteriesIncluded"
LABEL org.opencontainers.image.source="https://github.com/Siqsuruq/naviserver/tree/main/AlpineTclBatteriesIncluded"

# Copy built Tcl from the builder stage and install essential packages
COPY --from=builder /usr/local /usr/local

# Install necessary runtime dependencies and perform clean-up in a single RUN command
# Installing rlwrap and create an alias for tclsh
RUN apk add --no-cache bash musl libpq openssl zlib libpng curl rlwrap \
	&& echo 'alias tclsh="rlwrap tclsh8.6"' >> /etc/profile \
    && rm -rf /var/cache/apk/*

# Copy the .tclshrc file into the home directory
COPY .tclshrc /root/.tclshrc

# This will run tclsh with rlwrap
CMD ["rlwrap", "tclsh8.6"]
