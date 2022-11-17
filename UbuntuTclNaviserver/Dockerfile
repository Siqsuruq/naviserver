# Base Image Ubuntu with Tcl, use to create Naviserver
FROM siqsuruq/ubuntu-tcl

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Naviserver"

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib
ARG TCL_LIB=/usr/share/tcltk

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

# Compile and install nsshell
RUN git clone https://maksym_zinchenko@bitbucket.org/naviserver/nsshell.git ${NS_HOME}/src/nsshell \
 	&& cd ${NS_HOME}/src/nsshell \
	&& make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src
	
# Compile and install revproxy
RUN git clone https://bitbucket.org/naviserver/revproxy.git ${NS_HOME}/src/revproxy \
 	&& cd ${NS_HOME}/src/revproxy \
	&& make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src

# Compile and install nsstats
RUN git clone https://bitbucket.org/naviserver/nsstats.git ${NS_HOME}/src/nsstats \
 	&& cd ${NS_HOME}/src/nsstats \
	&& make NAVISERVER=$NS_HOME install \
	&& rm -rf ${NS_HOME}/src

RUN groupadd nsadmin
RUN useradd -Ms /bin/bash -g nsadmin nsadmin \
	&& chown -R nsadmin:nsadmin ${NS_HOME}
	
ADD ./ns-config.tcl ${NS_HOME}/conf/

VOLUME ${NS_HOME}/logs
WORKDIR $NS_HOME
EXPOSE 80 443

ENTRYPOINT /opt/ns/bin/nsd -u nsadmin -t /opt/ns/conf/ns-config.tcl -f