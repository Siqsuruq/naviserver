# Naviserver Docker Image Setup Guide

## Getting Started

This guide provides instructions for building and running a Docker image, `siqsuruq/naviserver`.

### Prerequisites

- Docker installed on your machine.
- Basic knowledge of Docker, Tcl and Naviserver.

## Step 1: Getting an Image

You can build the image yourself or pull it from Docker Hub.

#### Building the Image

To build the image from the Dockerfile, use the following command:

```bash
./build.sh
```
This script will execute the necessary Docker build commands to create the image.

#### Pulling Image from Docker Hub

This image is also available on Docker Hub, you can pull it using:

```
docker pull siqsuruq/naviserver
```

## Step 2: Preparing the Environment Before Running the Container.


To streamline the process of running the Naviserver container, it's essential to set up a specific directory structure on your host system. This structure will facilitate data sharing between your host and the Docker container through mounted volumes.

#### Create the Naviserver Home Directory:

Create a new directory that will serve as the Naviserver home. For example, create a directory at /opt/myns:

```
mkdir -p /opt/myns
```

Inside your Naviserver home directory (/opt/myns), create three subdirectories: logs, pages, and modules/nsssl:

```
mkdir -p /opt/myns/logs /opt/myns/pages /opt/myns/modules/nsssl
```
- /opt/myns/logs: Naviserver will store its log files here.

- /opt/myns/pages: This is where you can place your index.html or index.adp files to be served by the server.

- /opt/myns/modules/nsssl: This directory should contain your SSL/TLS certificates.

#### Configure the run.sh Script:

Edit the run.sh script to set the NS_HOME variable to the directory you just created:

```
NS_HOME=/opt/myns
```

HTTP Ports, Container Name, and Domain Name:
Modify the script or the Docker run command to reflect the correct HTTP ports, container name, and domain name as per your requirements.

Database Settings:
Ensure that the database settings (username, password, port, etc.) are correctly configured in the script or Docker run command. By default it will asume that PostgreSQL server is running on host.

Place your SSL/TLS certificate in the /opt/myns/modules/nsssl directory
The certificate should be in .pem format and named appropriately (e.g., yourdomain.com.pem or subdomain.domain.com.pem).

For the Naviserver inside the container to operate effectively, the mounted directories on the host must be accessible by the nsadmin user and group, which should correspond to the user and group used by Naviserver inside the container.

```
sudo groupadd nsadmin
sudo useradd -r -s /bin/false -g nsadmin nsadmin
```

Note: The -r flag creates a system user, and -s /bin/false ensures this user can't log in, which is a common practice for users dedicated to services.

Once the user and group are set up, adjust the ownership and permissions of the directories so that the nsadmin user and group have the necessary access.

Change the ownership of the Naviserver home directory and its subdirectories:

```
sudo chown -R nsadmin:nsadmin /opt/myns
sudo chmod -R 750 /opt/myns
```


####  Final example of run.sh and directory structure:
So in the end you will end up with folders structure like that:

```
/opt/myns/logs
/opt/myns/pages/index.html
/opt/myns/modules/nsssl/mydomain.com.pem
```

And run.sh script like that:

```
#!/bin/bash

# Please set up name for container, hostname and ports
NS_HOME=/opt/myns
CTNR=myns
HOSTNAME=mydomain.com
SPORT=7003
NPORT=7004
DB_PORT=5432
DB_USER=postgres
DB_PASS=123

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
	--detach=true naviserver:latest
```
## Step 3: Preparing the Environment Before Running the Container.

Make the run.sh script executable and run it: 

```
chmod a+x run.sh
./run.sh
```

## Customizing Naviserver Configuration.

For advanced users requiring specific configurations beyond the default setup, you can modify ns-config.tcl file. This file is the primary configuration script for Naviserver Docker Image. Refer to the Official Naviserver documentation for detailed information on the available settings and their implications.