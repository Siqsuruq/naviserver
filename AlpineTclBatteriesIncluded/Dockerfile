# Base Alpine Image with Tcl and Tcllib
# Stage 1: Builder
FROM alpine:latest AS builder

ARG TCL_BUILD_HOME=/opt/tcl_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib

# Install dependencies, download and install Tcl, and clean up in a single RUN command to reduce layers
RUN apk add --no-cache bash gcc musl-dev libpq-dev openssl openssl-dev build-base zlib-dev autoconf tar gzip git libpng-dev \
    && wget https://sourceforge.net/projects/tcl/files/Tcl/8.6.14/tcl8614-src.zip -O tcl.zip \
    && mkdir -p ${TCL_BUILD_HOME}/tcl \
    && unzip tcl.zip -d ${TCL_BUILD_HOME}/tcl \
    && cd ${TCL_BUILD_HOME}/tcl/tcl8.6.14/unix \
    && ./configure --enable-64bit --enable-threads \
    && make \
    && make install \
	&& wget https://github.com/tcltk/tcllib/archive/refs/tags/tcllib-1-21.zip -O tcllib-1-21.zip \
    && mkdir -p ${TCL_BUILD_HOME}/tcllib \
    && unzip tcllib-1-21.zip -d ${TCL_BUILD_HOME}/tcllib \
    && cd ${TCL_BUILD_HOME}/tcllib/tcllib-tcllib-1-21/ \
    && ./configure \
	&& make install \
	&& wget tdom.org/index.html/zip/trunk/tdom-trunk.zip -O tdom-trunk.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tdom \
    && unzip tdom-trunk.zip -d ${TCL_BUILD_HOME}/tdom \
    && cd ${TCL_BUILD_HOME}/tdom/tdom-trunk/ \
	&& ./configure \
	&& make install \
	&& wget https://github.com/flightaware/Pgtcl/archive/refs/tags/v3.0.1.zip -O pgtcl.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/pgtcl \
    && unzip pgtcl.zip -d ${TCL_BUILD_HOME}/pgtcl \
    && cd ${TCL_BUILD_HOME}/pgtcl/Pgtcl-3.0.1/ \
	&& autoreconf \
    && ./configure && make \
	&& make install \
	&& wget https://core.tcl-lang.org/tcltls/zip/89a6207a57/tcltls-89a6207a57.zip -O tcltls-1.8.0.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tcltls \
	&& unzip tcltls-1.8.0.zip -d ${TCL_BUILD_HOME}/tcltls \
    && cd ${TCL_BUILD_HOME}/tcltls/tcltls-89a6207a57/ \
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
    && cd / \
    && rm -rf ${TCL_BUILD_HOME} tcl.zip /var/cache/apk/*

# Stage 2: Final Image
FROM alpine:latest

# Metadata using OCI Image Format Specification annotations
LABEL org.opencontainers.image.title="Alpine Tcl/Tcllib Image"
LABEL org.opencontainers.image.description="A custom Docker image with Alpine, Tcl, and Tcllib."
LABEL org.opencontainers.image.version="0.1"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.authors="admin@cloudz.cv"
LABEL org.opencontainers.image.vendor="Cloudz"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/Siqsuruq/naviserver/tree/main/AlpineTclBaseImage"
LABEL org.opencontainers.image.documentation="https://github.com/Siqsuruq/naviserver/tree/main/AlpineTclBaseImage"
LABEL org.opencontainers.image.source="https://github.com/Siqsuruq/naviserver/tree/main/AlpineTclBaseImage"

# Copy built Tcl from the builder stage and install essential packages
COPY --from=builder /usr/local /usr/local

# Install necessary runtime dependencies and perform clean-up in a single RUN command
# Instlling Tcl-tls because fossil version has broken build
RUN apk add --no-cache bash musl libpq openssl zlib libpng \
    && rm -rf /var/cache/apk/*

# Set the default command to execute when creating a new container
CMD ["bash"]