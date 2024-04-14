# Base Alpine Image with Tcl and Tcllib
# Stage 1: Builder
FROM siqsuruq/tcl:tclbi-alpine AS builder

ARG TCL_BUILD_HOME=/opt/tcl_build
ARG TCL_LIB=/usr/local/lib
ARG NS_HOME=/opt/ns
ARG NS_BUILD_HOME=/opt/ns_build
ARG PG_INCL=/usr/include/postgresql
ARG PG_LIB=/usr/lib

# Install dependencies, download and install Tcl, and clean up in a single RUN command to reduce layers
RUN apk add --no-cache bash gcc musl-dev libpq-dev openssl openssl-dev build-base zlib-dev autoconf tar gzip git libpng-dev curl curl-dev automake \
	&& git clone https://github.com/naviserver-project/naviserver.git ${NS_BUILD_HOME}/src/naviserver \
 	&& cd ${NS_BUILD_HOME}/src/naviserver \
	&& ./autogen.sh --prefix=$NS_HOME --enable-symbols --enable-threads --enable-64bit \
	&& make && make install \
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
	&& rm -rf ${NS_BUILD_HOME}/src \
    && cd / \
    && rm -rf ${TCL_BUILD_HOME} tcl.zip /var/cache/apk/*

# Stage 2: Final Image
FROM siqsuruq/tcl:tclbi-alpine

ARG NS_HOME=/opt/ns

# Metadata using OCI Image Format Specification annotations
LABEL org.opencontainers.image.title="Alpine Naviserver Image"
LABEL org.opencontainers.image.description="A custom Docker image Naviserver."
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.authors="admin@cloudz.cv"
LABEL org.opencontainers.image.vendor="Cloudz"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.url="https://github.com/Siqsuruq/naviserver/tree/main/AlpineNaviserver"
LABEL org.opencontainers.image.documentation="https://github.com/Siqsuruq/naviserver/tree/main/AlpineNaviserver"
LABEL org.opencontainers.image.source="https://github.com/Siqsuruq/naviserver/tree/main/AlpineNaviserver"

# Copy built Tcl from the builder stage and install essential packages
COPY --from=builder /usr/local /usr/local
COPY --from=builder /opt/ns /opt/ns
# Install necessary runtime dependencies and perform clean-up in a single RUN command
# Instlling Tcl-tls because fossil version has broken build
RUN apk add --no-cache bash musl libpq openssl zlib libpng curl \
	# Add user 'nsadmin' with no login shell
	&& addgroup -S nsadmin && adduser -S nsadmin -g nsadmin -s /sbin/nologin \
	&& chown -R nsadmin:nsadmin ${NS_HOME} \
    && rm -rf /var/cache/apk/*

ADD ./ns-config.tcl ${NS_HOME}/conf/

VOLUME ${NS_HOME}/logs
WORKDIR $NS_HOME
EXPOSE 80 443

ENTRYPOINT /opt/ns/bin/nsd -u nsadmin -t /opt/ns/conf/ns-config.tcl -f
