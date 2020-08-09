#! /bin/bash

if [ -d "download" ]; then
    rm -rf download
fi

mkdir download
cd download || (echo "Unable to change directory" && exit 1)

wget https://github.com/lxsang/ant-http/raw/master/dist/antd-1.0.4b.tar.gz
tar xvzf antd-1.0.4b.tar.gz
rm antd-1.0.4b.tar.gz

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

git clone --depth 1 https://github.com/lxsang/antd-web-apps
git clone --depth 1 https://github.com/lxsang/antos

cd ../


docker build -t antosaio .

if [ -d "download" ]; then
    rm -rf download
fi

mkdir -p dist
docker save antosaio > dist/antosaio.tar
# sudo docker run -p 8080:80 -it antosaoi /bin/sh