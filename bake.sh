#! /bin/bash

if [ ! -d "download" ]; then
    mkdir download
    cd download || (echo "Unable to change directory" && exit 1)

    wget https://github.com/lxsang/ant-http/raw/master/dist/antd-1.0.6b.tar.gz
    tar xvzf antd-1.0.6b.tar.gz
    rm antd-1.0.6b.tar.gz

    wget https://github.com/lxsang/antd-lua-plugin/raw/master/dist/lua-0.5.2b.tar.gz
    tar xvzf lua-0.5.2b.tar.gz
    rm lua-0.5.2b.tar.gz

    wget https://github.com/lxsang/antd-wterm-plugin/raw/master/dist/wterm-1.0.0b.tar.gz
    tar xvzf wterm-1.0.0b.tar.gz
    rm wterm-1.0.0b.tar.gz

    wget https://github.com/lxsang/antd-tunnel-plugin/raw/master/dist/tunnel-0.1.0b.tar.gz
    tar xvzf tunnel-0.1.0b.tar.gz
    rm tunnel-0.1.0b.tar.gz

    wget https://github.com/lxsang/antd-tunnel-publishers/raw/master/dist/antd-publishers-0.1.0a.tar.gz
    tar xvzf antd-publishers-0.1.0a.tar.gz
    rm antd-publishers-0.1.0a.tar.gz

    git clone --depth 1 https://github.com/lxsang/antd-web-apps y-antd-web-apps
    wget https://github.com/lxsang/antos/raw/next-1.2.0/release/antos-1.2.0.tar.gz
    mkdir -p z-antos
    tar xvzf antos-1.2.0.tar.gz -C z-antos
    rm antos-1.2.0.tar.gz
    cd ../

fi

# this require docker buildx plugin
# https://github.com/docker/buildx#installing
# may need to execute this first
# docker buildx create --use
# Register Arm executables to run on x64 machines
# docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 


docker buildx build \
    --push \
    --platform linux/arm/v7,linux/arm64/v8,linux/amd64 \
    --tag xsangle/antosaio:latest .
