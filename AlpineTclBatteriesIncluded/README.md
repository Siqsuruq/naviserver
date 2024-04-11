# Alpine-based Tcl batteries-included Image

This Docker image provides a lightweight, Alpine-based environment equipped with Tcl (Tool Command Language),Tcllib and some more Tcl packages, offering a robust platform for developing and running Tcl applications. Ideal for Tcl enthusiasts and developers looking for a minimal yet fully-functional Tcl execution environment, this image is optimized for performance, size, and ease of use. Whether you're developing applications, scripts, or just exploring Tcl, siqsuruq/tcl:tclbi-alpine is the perfect starting point."

At this point image brings:

- tcl 8.6.14 [official documentation](https://www.tcl-lang.org/man/tcl8.6/)
- tcllib 1.21 [list of packages included](https://core.tcl-lang.org/tcllib/doc/tcllib-1-21/embedded/md/toc.md)
- tdom 0.9.3
- Pgtcl 3.0.1
- tls 1.8.0
- nsf 2.4.0
- tzint 1.1.0
- TclCurl 7.22.0
- vfs 1.4.2

### Prerequisites

- Docker installed on your machine.
- Basic knowledge of Docker and Tcl.

### Installing

You can build the image yourself or pull it from [Docker Hub](https://hub.docker.com/r/siqsuruq/tcl/tags).

#### Building the Image

To build the image from the Dockerfile, use the following command:

```bash
./build.sh
```

This script will execute the necessary Docker build commands to create the image.

#### Pulling from Docker Hub

If the image is available on [Docker Hub](https://hub.docker.com/r/siqsuruq/tcl/tags), you can pull it using:

```
docker pull siqsuruq/tcl:tclbi-alpine
```

### Running the Image

To run the image in interactive mode:

Run into tclsh8.6:

```bash
docker run -it siqsuruq/tcl:tclbi-alpine tclsh8.6
```
Run into bash:

```bash
docker run -it siqsuruq/tcl:tclbi-alpine bash
```