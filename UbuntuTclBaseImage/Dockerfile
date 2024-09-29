# Base Ubuntu Image with Tcl and Tcllib
# Stage 1: Build Stage
FROM ubuntu:latest AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG TCL_BUILD_HOME=/opt/tcl_build
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TCL_LIB=/usr/local/lib
# Install build dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends wget unzip build-essential ca-certificates zlib1g-dev libpq-dev libpng-dev libcurl4-openssl-dev automake git \
	&& apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& wget https://sourceforge.net/projects/tcl/files/Tcl/8.6.15/tcl8615-src.zip -O tcl.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tcl \
    && unzip tcl.zip -d ${TCL_BUILD_HOME}/tcl \
    && cd ${TCL_BUILD_HOME}/tcl/tcl8.6.15/unix \
    && ./configure --enable-64bit --enable-threads \
    && make \
    && make install \
	&& wget https://github.com/tcltk/tcllib/archive/refs/tags/tcllib-1-21.zip -O tcllib-1-21.zip \
    && mkdir -p ${TCL_BUILD_HOME}/tcllib \
    && unzip tcllib-1-21.zip -d ${TCL_BUILD_HOME}/tcllib \
    && cd ${TCL_BUILD_HOME}/tcllib/tcllib-tcllib-1-21/ \
    && ./configure && make install \
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
	&& wget https://github.com/flightaware/tclcurl-fa/archive/refs/tags/v7.22.0.zip -O v7.22.0.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/tclcurl \
    && unzip v7.22.0.zip -d ${TCL_BUILD_HOME}/tclcurl \
    && cd ${TCL_BUILD_HOME}/tclcurl/tclcurl-fa-7.22.0/ \
    && ./configure --enable-64bit && make \
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
	&& ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
	&& ./configure --with-png-lib=/usr/lib/x86_64-linux-gnu/ --enable-64bit && make \
	&& make install-binaries install-libraries \
	&& wget --no-check-certificate https://core.tcl-lang.org/tclvfs/zip/72e30db4a7/tclvfs-72e30db4a7.zip -O tclvfs-72e30db4a7.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/src/vfs/ \
	&& unzip tclvfs-72e30db4a7.zip -d ${TCL_BUILD_HOME}/src/vfs \
	&& mv ${TCL_BUILD_HOME}/src/vfs/tclvfs-72e30db4a7/* ${TCL_BUILD_HOME}/src/vfs/ \
	&& wget --no-check-certificate https://core.tcl-lang.org/tclconfig/zip/2a8174cc0c/TEA+%28tclconfig%29+Source+Code-2a8174cc0c.zip -P ${TCL_BUILD_HOME}/src/vfs/ -O ${TCL_BUILD_HOME}/src/vfs/tclconfig.zip \
	&& unzip ${TCL_BUILD_HOME}/src/vfs/tclconfig.zip -d ${TCL_BUILD_HOME}/src/vfs/tclconfig \
	&& mv ${TCL_BUILD_HOME}/src/vfs/tclconfig/TEA*/* ${TCL_BUILD_HOME}/src/vfs/tclconfig/ \
	&& cd ${TCL_BUILD_HOME}/src/vfs \
	&& ./configure && make && make install \
	&& git clone https://github.com/aschoepe/ooxml.git ${TCL_BUILD_HOME}/src/ooxml \
 	&& cd ${TCL_BUILD_HOME}/src/ooxml \
	&& ./configure && make && make install \
	&& git clone https://github.com/Siqsuruq/money-tcl-package.git ${TCL_BUILD_HOME}/src/money \
	&& cp -r ${TCL_BUILD_HOME}/src/money/money $TCL_LIB/ \
	&& git clone https://github.com/Siqsuruq/mimext.git ${TCL_BUILD_HOME}/src/mimext \
	&& cp -r ${TCL_BUILD_HOME}/src/mimext $TCL_LIB/ \
	&& git clone https://github.com/Siqsuruq/hrfilesize.git ${TCL_BUILD_HOME}/src/hrfilesize \
	&& cp -r ${TCL_BUILD_HOME}/src/hrfilesize $TCL_LIB/ \
	&& wget https://github.com/Kazmirchuk/nats-tcl/archive/refs/tags/v3.0.zip \
	&& mkdir -p ${TCL_BUILD_HOME}/nats \
	&& unzip v3.0.zip -d ${TCL_BUILD_HOME}/nats \
	&& cp -r ${TCL_BUILD_HOME}/nats/nats-tcl-3.0 $TCL_LIB/ 
	
# Stage 2: Final Image
FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
ARG WORKDIR=/opt/tcltk
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Copy built Tcl from the builder stage and install essential packages
COPY --from=builder /usr/local /usr/local

# Install runtime dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends bash openssl curl libpq5 rlwrap \
	&& apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* 

# Cleanup
RUN rm -rf ${TCL_BUILD_HOME}/src

# Set working directory
WORKDIR ${WORKDIR}

# Copy the .tclshrc file into the home directory
COPY .tclshrc /root/.tclshrc

# Entrypoint
CMD ["rlwrap", "tclsh8.6"]
