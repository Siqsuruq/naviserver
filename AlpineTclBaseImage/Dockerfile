# Base Alpine Image with Tcl and Tcllib
# Stage 1: Builder
FROM alpine:latest AS builder

ARG TCL_BUILD_HOME=/opt/tcl_build

# Install dependencies, download and install Tcl, and clean up in a single RUN command to reduce layers
RUN apk add --no-cache bash gcc musl-dev openssl openssl-dev build-base zlib-dev \
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
RUN apk add --no-cache bash musl openssl zlib libpng rlwrap \
	&& echo 'alias tclsh="rlwrap tclsh8.6"' >> /etc/profile \
    && rm -rf /var/cache/apk/*

# Copy the .tclshrc file into the home directory
COPY .tclshrc /root/.tclshrc

# Set the default command to execute when creating a new container
CMD ["rlwrap", "tclsh8.6"]
