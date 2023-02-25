# Base Image Alpine with Tcl, used as base to create other images
FROM alpine:latest

FROM alpine:3.14
RUN apk update \
	&& apk add tcl 

LABEL maintainer="admin@cloudz.cv"
LABEL version="0.1"
LABEL description="This is custom Docker Image for Alpine and Tcl"