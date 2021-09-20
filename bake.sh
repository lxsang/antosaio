#! /bin/bash

# this require docker buildx plugin
# https://github.com/docker/buildx#installing
# may need to execute this first
# docker buildx create --use
# Register Arm executables to run on x64 machines
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 


docker buildx build \
    --push \
    --platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
    --tag xsangle/antosaio:latest .
