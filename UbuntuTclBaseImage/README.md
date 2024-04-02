# UbuntuTclBaseImage

UbuntuTclBaseImage is a Docker image that provides a Tcl (Tool Command Language) environment on top of an Ubuntu base. 
When this image is run, `tclsh` (Tcl shell) is exposed as the default shell, allowing users to execute Tcl scripts and commands within an Ubuntu environment.

## Getting Started

These instructions will cover usage information and for the docker container 

### Prerequisites

- Docker installed on your machine.
- Basic knowledge of Docker and Tcl.

### Installing

You can build the image yourself or pull it from Docker Hub.

#### Building the Image

To build the image from the Dockerfile, use the following command:

```bash
./build.sh
```

This script will execute the necessary Docker build commands to create the image.

#### Pulling from Docker Hub

If the image is available on Docker Hub, you can pull it using:

```
docker pull siqsuruq/ubuntu-tcl:latest
```

### Running the Image

To run the image with tclsh exposed as the shell, you can use the provided run.sh script:

```bash
./run.sh
```

### Usage

Once the container is running, you will be dropped into a tclsh shell where you can start executing your Tcl scripts or commands.