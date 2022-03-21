FROM ubuntu:20.04

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Naviserver"

ARG DEBIAN_FRONTEND=noninteractive
ARG NS_HOME=/opt/ns

# General Dependencies
RUN apt-get -y update && apt-get -y install unzip tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev automake nsf nsf-shells fortune fortunes mc file git gcc zip

# PostgreSQL
# postgresql postgresql-contrib postgresql-pltcl


WORKDIR $NS_HOME/src