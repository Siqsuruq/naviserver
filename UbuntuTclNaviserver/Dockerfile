# Stage 1: Build Stage
FROM siqsuruq/ubuntu-tcl AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns
ARG NS_BUILD_HOME=/opt/ns_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk

# Install build dependencies
RUN export LANG="en_US.UTF-8" \
    && export LC_ALL="en_US.UTF-8" \
    && apt-get update \
    && apt-get install -y --no-install-recommends locales unzip automake git gcc zip wget lsb-release xz-utils \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG="en_US.UTF-8" \
    && update-locale LC_ALL="en_US.UTF-8" \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
    && git config --global http.sslverify false \
    && git config --global https.sslverify false \
	# Compile and install Naviserver
	&& git clone https://github.com/naviserver-project/naviserver.git ${NS_BUILD_HOME}/src/naviserver \
 	&& cd ${NS_BUILD_HOME}/src/naviserver \
	&& ./autogen.sh --prefix=$NS_HOME --enable-symbols --enable-threads && make \
	# Compile and install NS_DBPG
	&& git clone https://github.com/naviserver-project/nsdbpg.git ${NS_BUILD_HOME}/src/nsdbpg \
 	&& cd ${NS_BUILD_HOME}/src/nsdbpg \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL \
	# Compile and install NS_DBI
	&& git clone https://github.com/naviserver-project/nsdbi.git ${NS_BUILD_HOME}/src/nsdbi \
 	&& cd ${NS_BUILD_HOME}/src/nsdbi \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL \	
	# Compile and install NS_DBIPG
	&& git clone https://github.com/naviserver-project/nsdbipg.git ${NS_BUILD_HOME}/src/nsdbipg \
 	&& cd ${NS_BUILD_HOME}/src/nsdbipg \
	&& make NAVISERVER=$NS_HOME PGINCLUDE=$PG_INCL \
	# Compile and install NS_FORTUNE
	&& git clone https://github.com/naviserver-project/nsfortune.git ${NS_BUILD_HOME}/src/nsfortune \
 	&& cd ${NS_BUILD_HOME}/src/nsfortune \
	&& make NAVISERVER=$NS_HOME \
	# Compile and install nsshell
	&& git clone https://github.com/naviserver-project/nsshell.git ${NS_BUILD_HOME}/src/nsshell \
 	&& cd ${NS_BUILD_HOME}/src/nsshell \
	# Compile and install revproxy
	&& git clone https://github.com/naviserver-project/revproxy.git ${NS_BUILD_HOME}/src/revproxy \
 	&& cd ${NS_BUILD_HOME}/src/revproxy \
	# Compile and install nsstats
	&& git clone https://github.com/naviserver-project/nsstats.git ${NS_BUILD_HOME}/src/nsstats \
 	&& cd ${NS_BUILD_HOME}/src/nsstats
	

# Stage 2: Final Image
FROM siqsuruq/ubuntu-tcl

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.3"
LABEL description="This is custom Docker Image for Naviserver"

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns
ARG NS_BUILD_HOME=/opt/ns_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk

COPY --from=builder ${NS_BUILD_HOME} ${NS_BUILD_HOME}

# Compile and install NS
RUN export LANG="en_US.UTF-8" \
    && export LC_ALL="en_US.UTF-8" \
    && apt-get update \
    && apt-get install -y --no-install-recommends make \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG="en_US.UTF-8" \
    && update-locale LC_ALL="en_US.UTF-8" \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* \
	&& cd ${NS_HOME}/src/naviserver \
	&& make install \
 	&& cd ${NS_BUILD_HOME}/src/nsdbpg \
	&& make NAVISERVER=$NS_HOME install \
 	&& cd ${NS_BUILD_HOME}/src/nsdbi \
	&& make NAVISERVER=$NS_HOME install \
 	&& cd ${NS_BUILD_HOME}/src/nsdbipg \
	&& make NAVISERVER=$NS_HOME install \
 	&& cd ${NS_BUILD_HOME}/src/nsfortune \
	&& make NAVISERVER=$NS_HOME install \
 	&& cd ${NS_BUILD_HOME}/src/nsshell \
	&& make NAVISERVER=$NS_HOME install \
 	&& cd ${NS_BUILD_HOME}/src/revproxy \
	&& make NAVISERVER=$NS_HOME install \
 	&& cd ${NS_BUILD_HOME}/src/nsstats \
	&& make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_BUILD_HOME}/src

RUN groupadd nsadmin
RUN useradd -Ms /bin/bash -g nsadmin nsadmin \
	&& chown -R nsadmin:nsadmin ${NS_HOME}
	
ADD ./ns-config.tcl ${NS_HOME}/conf/

VOLUME ${NS_HOME}/logs
WORKDIR $NS_HOME
EXPOSE 80 443

ENTRYPOINT /opt/ns/bin/nsd -u nsadmin -t /opt/ns/conf/ns-config.tcl -f