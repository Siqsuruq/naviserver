#!/bin/bash

# Please set up name for container, hostname and ports
CTRN=test
HOSTNAME=test.mydomain.org
SPORT=7001
NPORT=7002
echo "############################################"
echo "Setting up container: $CTRN"


docker run --name=${CTRN} \
	-e DB_HOST_IP=$(hostname -I | cut -f1 -d' ') \
	-e DB_NAME=${CTRN} \
	--hostname=${HOSTNAME} \
	-p ${SPORT}:443 \
	-p ${NPORT}:80 \
	--env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	--volume=/opt/ns/clients/${CTRN}:/opt/ns/client \
	--volume=/opt/ns/modules/nsssl:/opt/ns/modules/nsssl \
	--volume=/opt/ns/logs \
	--volume=/opt/ns/client \
	--volume=/opt/ns/modules/nsssl \
	--workdir=/opt/ns \
	--restart=always \
	--runtime=runc \
	--detach=true naviserver:latest
