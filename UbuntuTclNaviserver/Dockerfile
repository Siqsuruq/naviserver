# Stage 1: Build Naviserver Stage
FROM siqsuruq/ubuntu-tcl AS naviserver-builder

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns
ARG NS_BUILD_HOME=/opt/ns_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV TCL_LIB=/usr/local/lib

# Install build dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends locales unzip automake git gcc zip wget lsb-release xz-utils openssl build-essential zlib1g-dev libssl-dev libpq-dev  \
    && locale-gen C.UTF-8 \
    && update-locale LANG=C.UTF-8 \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && git config --global http.sslverify false \
    && git config --global https.sslverify false \
	# Compile and install Naviserver
	&& git clone https://github.com/naviserver-project/naviserver.git ${NS_BUILD_HOME}/src/naviserver \
 	&& cd ${NS_BUILD_HOME}/src/naviserver \
	&& ./autogen.sh --prefix=$NS_HOME --enable-threads --enable-64bit && make && make install \
	# Compile and install NS_DBPG
	&& git clone https://github.com/naviserver-project/nsdbpg.git ${NS_BUILD_HOME}/src/nsdbpg \
 	&& cd ${NS_BUILD_HOME}/src/nsdbpg \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL && make NAVISERVER=$NS_HOME install \
	# Compile and install NS_DBI
	&& git clone https://github.com/naviserver-project/nsdbi.git ${NS_BUILD_HOME}/src/nsdbi \
 	&& cd ${NS_BUILD_HOME}/src/nsdbi \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL && make NAVISERVER=$NS_HOME install \	
	# Compile and install NS_DBIPG
	&& git clone https://github.com/naviserver-project/nsdbipg.git ${NS_BUILD_HOME}/src/nsdbipg \
 	&& cd ${NS_BUILD_HOME}/src/nsdbipg \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL && make NAVISERVER=$NS_HOME install \
	# Compile and install NS_FORTUNE
	&& git clone https://github.com/naviserver-project/nsfortune.git ${NS_BUILD_HOME}/src/nsfortune \
 	&& cd ${NS_BUILD_HOME}/src/nsfortune \
	&& make NAVISERVER=$NS_HOME && make NAVISERVER=$NS_HOME install \
	# Compile and install nsshell
	&& git clone https://github.com/naviserver-project/nsshell.git ${NS_BUILD_HOME}/src/nsshell \
 	&& cd ${NS_BUILD_HOME}/src/nsshell \
	&& make NAVISERVER=$NS_HOME && make NAVISERVER=$NS_HOME install \
	# Compile and install revproxy
	&& git clone https://github.com/naviserver-project/revproxy.git ${NS_BUILD_HOME}/src/revproxy \
 	&& cd ${NS_BUILD_HOME}/src/revproxy \
	&& make NAVISERVER=$NS_HOME && make NAVISERVER=$NS_HOME install \
	# Compile and install nsstats
	&& git clone https://github.com/naviserver-project/nsstats.git ${NS_BUILD_HOME}/src/nsstats \
 	&& cd ${NS_BUILD_HOME}/src/nsstats \
	&& make NAVISERVER=$NS_HOME && make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_BUILD_HOME}/src
	


# Stage 2: Final Image
FROM siqsuruq/ubuntu-tcl

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns
ARG TCL_LIB=/usr/share/tcltk
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

COPY --from=naviserver-builder ${NS_HOME} ${NS_HOME}

# Compile and install NS
RUN apt-get update \
    && apt-get install -y --no-install-recommends fortune imagemagick brotli libxml2 \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& groupadd nsadmin \
	&& useradd -Ms /bin/bash -g nsadmin nsadmin \
	&& chown -R nsadmin:nsadmin ${NS_HOME}
	
ADD ./ns-config.tcl ${NS_HOME}/conf/

VOLUME ${NS_HOME}/logs
WORKDIR $NS_HOME
EXPOSE 80 443

ENTRYPOINT /opt/ns/bin/nsd -u nsadmin -t /opt/ns/conf/ns-config.tcl -f