#!/bin/bash

# Please set up name for container, hostname and ports
NS_HOME=/opt/tst
CTNR=tst
HOSTNAME=tst.daidze.org
SPORT=7003
NPORT=7004
DB_PORT=5432
DB_USER=postgres
DB_PASS=P05tgre5!.

echo "############################################"
echo "Setting up container: $CTNR"


docker run --name=${CTNR} \
	-e DB_HOST_IP=$(hostname -I | cut -f1 -d' ') \
	-e DB_NAME=${CTNR} \
	-e DB_PORT=${DB_PORT} \
	-e DB_USER=${DB_USER} \
	-e DB_PASS=${DB_PASS} \
	--hostname=${HOSTNAME} \
	-p ${SPORT}:443 \
	-p ${NPORT}:80 \
	--env=PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
	--volume=${NS_HOME}/modules/nsssl:/opt/ns/modules/nsssl \
	--volume=${NS_HOME}/logs:/opt/ns/logs \
	--volume=${NS_HOME}/pages:/opt/ns/pages \
	--workdir=/opt/ns \
	--restart=always \
	--runtime=runc \
	--detach=true naviserver-alpine