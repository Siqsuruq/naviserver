FROM ubuntu:20.04

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Naviserver"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -y install unzip tcl tcl-dev tcllib tdom tcl-tls tcl-thread libssl-dev libpng-dev libpq-dev automake postgresql postgresql-contrib postgresql-pltcl nsf nsf-shells fortune fortunes mc file git gcc zip

WORKDIR /opt/ns
