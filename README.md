# Docker Images Repository

This repository contains a collection of Docker images designed for various purposes. Each image is organized into its own directory, where you can find the Dockerfile and additional resources required to build the image.

## Images

### AlpineTclBaseImage

This image serves as a base image with Tcl and tcllib installed on Alpine Linux. It's optimized for size, making it an excellent choice for Tcl applications that require a minimal footprint. Size: 38.3 MB

**Directory:** `AlpineTclBaseImage/`

### AlpineTclBatteriesIncluded

This image also serves as a base image with Tcl, tcllib plus aditional packages installed on Alpine Linux. It's optimized for size, making it an excellent choice for Tcl applications that require a minimal footprint. Size: 48.6 MB

**Directory:** `AlpineTclBatteriesIncluded/`

### NginxReverseProxy

A Docker image set up with Nginx, configured as a reverse proxy. It's ideal for routing traffic to your backend services or for providing additional layers of security.

**Directory:** `NginxReverseProxy/`

### UbuntuTclBaseImage

This image is a base image featuring Tcl on Ubuntu. It provides a robust environment for applications that require the extensive library support and packages available in Ubuntu.

**Directory:** `UbuntuTclBaseImage/`

**Docker Hub:** [siqsuruq/ubuntu-tcl](https://hub.docker.com/r/siqsuruq/ubuntu-tcl)

#### Included Ubuntu Packages

The image includes the following Ubuntu packages to ensure a comprehensive development and runtime environment:

- locales
- unzip
- tcl
- tcl-dev
- tcllib
- tdom
- tcl-tls
- tcl-thread
- libssl-dev
- libpng-dev
- libpq-dev
- automake
- nsf
- nsf-shells
- fortune
- fortunes
- imagemagick
- file
- git
- gcc
- zip
- libcurl4-openssl-dev
- wget
- iputils-ping
- brotli
- libxml2-utils
- and others.

#### Included Tcl Packages

The image is preloaded with several Tcl packages to facilitate development and enhance functionality:

- pgtcl: Tcl interface to PostgreSQL.
- money: Tcl package for monetary calculations.
- mimext: Tcl package to determine MIME types.
- hrfilesize: Tcl package for human-readable file size representation.
- tzint: Tcl extension for QR code generation.
- tclcurl: Tcl interface to the curl library.
- vfs: Virtual filesystem support for Tcl.
- ooxml: Tcl package to work with OOXML files.


### UbuntuTclNaviserver

Built on the Ubuntu base image, this Docker image includes the Tcl-powered Naviserver web server. It's suitable for running Tcl-based web applications.

**Directory:** `UbuntuTclNaviserver/`

### UbuntuTclNaviserverRevproxy

This image combines the Tcl-powered Naviserver with a reverse proxy setup, offering a comprehensive solution for serving web applications with an additional layer of security or load balancing.

**Directory:** `UbuntuTclNaviserverRevproxy/`

## Usage

To build any of these Docker images, navigate to the corresponding directory and run the Docker build command. For example, to build the `UbuntuTclBaseImage`, you would use:

```bash
cd UbuntuTclBaseImage
docker build -t your-tag-name .
