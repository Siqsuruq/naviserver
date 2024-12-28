#!/bin/bash
docker build --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") --pull --no-cache -t tcl-alpine .