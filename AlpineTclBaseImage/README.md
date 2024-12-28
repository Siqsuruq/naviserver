# Alpine-based Tcl Base Image

This Docker image provides a lightweight, Alpine-based environment equipped with Tcl (Tool Command Language) and Tcllib, offering a robust platform for developing and running Tcl applications. Ideal for Tcl enthusiasts and developers looking for a minimal yet fully-functional Tcl execution environment, this image is optimized for performance, size, and ease of use. Whether you're developing applications, scripts, or just exploring Tcl, siqsuruq/tcl is the perfect starting point."

- tcl 8.6.16 [official documentation](https://www.tcl-lang.org/man/tcl8.6/)
- tcllib 2.0 [list of packages included](https://core.tcl-lang.org/tcllib/doc/tcllib-2-0/embedded/md/toc.md)

Size of this image is around: 39.8 MB

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
docker pull siqsuruq/tcl:tcl-alpine
```

### Running the Image

To run the image in interactive mode:

Run into tclsh8.6 with rlwrap:

```bash
docker run -it siqsuruq/tcl:tcl-alpine
```
Run into bash:

```bash
docker run -it siqsuruq/tcl:tclbi-alpine bash
```
