# Base Image Ubuntu with Tcl, used as base to create other images
FROM ubuntu:22.04

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.2"
LABEL description="This is custom Docker Image for Ubuntu and Tcl"

ARG DEBIAN_FRONTEND=noninteractive
ARG TCL_BUILD_HOME=/opt/tcl_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk

# General Dependencies
RUN export LANG="en_US.UTF-8" \
	&& export LC_ALL="en_US.UTF-8" \
	&& apt-get -y update \
	&& apt-get -y --no-install-recommends install locales unzip tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev automake nsf nsf-shells fortune fortunes imagemagick file git gcc zip libcurl4-openssl-dev wget iputils-ping brotli libxml2-utils \
	&& locale-gen en_US.UTF-8 \
	&& update-locale LANG="en_US.UTF-8" \
	&& update-locale LC_ALL="en_US.UTF-8" \
	&& apt-get clean \
	&& apt-get auto-remove -y \
	&& rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/* \
	&& git config --global http.sslverify false \
	&& git config --global https.sslverify false \
	# Compile and install Pgtcl
	&& git clone https://github.com/flightaware/Pgtcl.git ${TCL_BUILD_HOME}/src/pgtcl \
 	&& cd ${TCL_BUILD_HOME}/src/pgtcl \
	&& autoreconf && ./configure --with-postgres-include=$PG_INCL --with-postgres-lib=$PG_LIB && make install \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install money
	&& git clone https://github.com/Siqsuruq/money-tcl-package.git ${TCL_BUILD_HOME}/src/money \
 	&& cp -r ${TCL_BUILD_HOME}/src/money/money $TCL_LIB/ \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install mimext
	&& git clone https://github.com/Siqsuruq/mimext.git ${TCL_BUILD_HOME}/src/mimext \
 	&& cp -r ${TCL_BUILD_HOME}/src/mimext $TCL_LIB/ \
	&& rm -rf ${TCL_BUILD_HOME}/src	\
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install hrfilesize
	&& git clone https://github.com/Siqsuruq/hrfilesize.git ${TCL_BUILD_HOME}/src/hrfilesize \
 	&& cp -r ${TCL_BUILD_HOME}/src/hrfilesize $TCL_LIB/ \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install tzint
	&& git clone https://github.com/aschoepe/tzint.git ${TCL_BUILD_HOME}/src/tzint \
 	&& cd ${TCL_BUILD_HOME}/src/tzint \
	&& ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
	&& ./configure && make && make install \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install tclcurl
	&& git clone https://github.com/flightaware/tclcurl-fa.git ${TCL_BUILD_HOME}/src/tclcurl \
 	&& cd ${TCL_BUILD_HOME}/src/tclcurl \
	&& ./configure --enable-threads && make && make install \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install vfs
	&& wget --no-check-certificate https://core.tcl-lang.org/tclvfs/zip/72e30db4a7/tclvfs-72e30db4a7.zip -P ${TCL_BUILD_HOME}/src/vfs/ \
 	&& cd ${TCL_BUILD_HOME}/src/vfs \
	&& unzip tclvfs*.zip  \
	&& cd tclvfs* && wget --no-check-certificate https://core.tcl-lang.org/tclconfig/zip/2a8174cc0c/TEA+%28tclconfig%29+Source+Code-2a8174cc0c.zip -O tclconfig.zip \
	&& unzip tclconfig.zip -d tclconfig \
	&& cd tclconfig/TEA*  && mv * ../ && cd ../../ \
	&& autoconf && ./configure && make && make install \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME} \
	# Compile and install ooxml
	&& git clone https://github.com/aschoepe/ooxml.git ${TCL_BUILD_HOME}/src/ooxml \
 	&& cd ${TCL_BUILD_HOME}/src/ooxml \
	&& ./configure && make && make install \
	&& rm -rf ${TCL_BUILD_HOME}/src \
	&& cd ${TCL_BUILD_HOME}

WORKDIR $TCL_BUILD_HOME
