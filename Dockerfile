# Base Image Ubuntu with Tcl, use to create Naviserver
FROM ubuntu:22.04

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Naviserver"

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk

RUN export LANG="en_US.UTF-8" \
	&& export LC_ALL="en_US.UTF-8"
	
# General Dependencies
RUN apt-get -y update \
	&& apt-get -y --no-install-recommends install locales unzip tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev automake nsf nsf-shells fortune fortunes file git gcc zip libcurl4-openssl-dev wget \
	&& locale-gen en_US.UTF-8 \
	&& update-locale LANG="en_US.UTF-8" \
	&& update-locale LC_ALL="en_US.UTF-8" \
	&& apt-get clean \
	&& apt-get auto-remove -y \
	&& rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/* \
	&& git config --global http.sslverify false \
	&& git config --global https.sslverify false
	  
# Compile and install NS
RUN git clone https://bitbucket.org/naviserver/naviserver.git ${NS_HOME}/src/naviserver \
 	&& cd ${NS_HOME}/src/naviserver \
	&& ./autogen.sh --prefix=$NS_HOME --enable-symbols --enable-threads && make && make install \
	&& rm -rf ${NS_HOME}/src

# Compile and install NS_DBPG
RUN git clone https://bitbucket.org/naviserver/nsdbpg.git ${NS_HOME}/src/nsdbpg \
 	&& cd ${NS_HOME}/src/nsdbpg \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL && make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src

# Compile and install NS_DBI
RUN git clone https://bitbucket.org/naviserver/nsdbi.git ${NS_HOME}/src/nsdbi \
 	&& cd ${NS_HOME}/src/nsdbi \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL && make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src
	
# Compile and install NS_DBIPG
RUN git clone https://bitbucket.org/naviserver/nsdbipg.git ${NS_HOME}/src/nsdbipg \
 	&& cd ${NS_HOME}/src/nsdbipg \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL && make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src	

# Compile and install NS_FORTUNE
RUN git clone https://bitbucket.org/naviserver/nsfortune.git ${NS_HOME}/src/nsfortune \
 	&& cd ${NS_HOME}/src/nsfortune \
	&& make NAVISERVER=$NS_HOME && make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src

# Compile and install Pgtcl
RUN git clone https://github.com/flightaware/Pgtcl.git ${NS_HOME}/src/pgtcl \
 	&& cd ${NS_HOME}/src/pgtcl \
	&& autoreconf && ./configure --with-postgres-include=$PG_INCL --with-postgres-lib=$PG_LIB && make install \
	&& rm -rf ${NS_HOME}/src

# Compile and install money
RUN git clone https://github.com/Siqsuruq/money-tcl-package.git ${NS_HOME}/src/money \
 	&& cp -r ${NS_HOME}/src/money/money $TCL_LIB/ \
	&& rm -rf ${NS_HOME}/src

# Compile and install mimext
RUN git clone https://github.com/Siqsuruq/mimext.git ${NS_HOME}/src/mimext \
 	&& cp -r ${NS_HOME}/src/mimext $TCL_LIB/ \
	&& rm -rf ${NS_HOME}/src	
	
# Compile and install hrfilesize
RUN git clone https://github.com/Siqsuruq/hrfilesize.git ${NS_HOME}/src/hrfilesize \
 	&& cp -r ${NS_HOME}/src/hrfilesize $TCL_LIB/ \
	&& rm -rf ${NS_HOME}/src

# Compile and install tzint
RUN git clone https://github.com/aschoepe/tzint.git ${NS_HOME}/src/tzint \
 	&& cd ${NS_HOME}/src/tzint \
	&& ln -s /usr/lib/x86_64-linux-gnu/libpng.so /usr/lib/libpng.so \
	&& ./configure && make && make install \
	&& rm -rf ${NS_HOME}/src


# Compile and install tclcurl
RUN git clone https://github.com/flightaware/tclcurl-fa.git ${NS_HOME}/src/tclcurl \
 	&& cd ${NS_HOME}/src/tclcurl \
	&& ./configure --enable-threads && make && make install \
	&& rm -rf ${NS_HOME}/src
	
# Compile and install tclcurl
RUN wget --no-check-certificate https://core.tcl-lang.org/tclvfs/zip/72e30db4a7/tclvfs-72e30db4a7.zip -P ${NS_HOME}/src/vfs/ \
 	&& cd ${NS_HOME}/src/vfs \
	&& unzip tclvfs*.zip  \
	&& cd tclvfs* && wget --no-check-certificate https://core.tcl-lang.org/tclconfig/zip/2a8174cc0c/TEA+%28tclconfig%29+Source+Code-2a8174cc0c.zip -O tclconfig.zip \
	&& unzip tclconfig.zip -d tclconfig \
	&& cd tclconfig/TEA*  && mv * ../ && cd ../../ \
	&& autoconf && ./configure && make && make install \
	&& rm -rf ${NS_HOME}/src

# Compile and install ooxml
RUN git clone https://github.com/aschoepe/ooxml.git ${NS_HOME}/src/ooxml \
 	&& cd ${NS_HOME}/src/ooxml \
	&& ./configure && make && make install \
	&& rm -rf ${NS_HOME}/src

# Compile and install nsshell
RUN git clone https://maksym_zinchenko@bitbucket.org/naviserver/nsshell.git ${NS_HOME}/src/nsshell \
 	&& cd ${NS_HOME}/src/nsshell \
	&& make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src
	
RUN groupadd nsadmin
RUN useradd -Ms /bin/bash -g nsadmin nsadmin \
	&& chown -R nsadmin:nsadmin ${NS_HOME}
	
ADD ./ns-config.tcl ${NS_HOME}/conf/

VOLUME ${NS_HOME}/logs
WORKDIR $NS_HOME
EXPOSE 80 443 8000 8080

ENTRYPOINT /opt/ns/bin/nsd -u nsadmin -t /opt/ns/conf/ns-config.tcl -f