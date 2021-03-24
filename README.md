# antosaio

Docker image layer for All-in-one AntOS VDE system.
This layer allows to build a minimal docker image with an
out-of-the-box working AntOS system:

- The web-server (HTTP only) on port 80
- AntOS server side API
- AntOS client side API

## How it works ?
The following manual requires docker to be installed on the host system.

A prebuilt image can be found in `dist`, the image can be imported
to docker and ready to use:

```sh
wget https://github.com/lxsang/antosaio/raw/master/dist/antosaio.tar
sudo docker load < antosaio.tar
```

The image can be run in a container using

```sh

# app dir that will be mounted to the container
# the server configuration is stored in this location
mkdir -p /tmp/app/home

# create the server configuration
cat << EOF > /tmp/app/antd_config.ini
[SERVER]
plugins=/opt/www/lib/
plugins_ext=.so
database=/opt/www/database/
tmpdir=/opt/www/tmp/
maxcon=200
backlog=5000
workers = 4
max_upload_size = 10000000
gzip_enable = 1
gzip_types = text\/.*,.*\/css,.*\/json,.*\/javascript

[PORT:80]
htdocs=/opt/www/htdocs
ssl.enable=0
^/(.*)$ = /os/router.lua?r=<1>&<query>

[AUTOSTART]
plugin = tunnel

[MIMES]
image/bmp=bmp
image/jpeg=jpg,jpeg
text/css=css
text/markdown=md
text/csv=csv
application/pdf=pdf
image/gif=gif
text/html=html,htm,chtml
application/json=json
application/javascript=js
image/png=png
image/x-portable-pixmap=ppm
application/x-rar-compressed=rar
image/tiff=tiff
application/x-tar=tar
text/plain=txt
application/x-font-ttf=ttf
application/xhtml+xml=xhtml
application/xml=xml
application/zip=zip
image/svg+xml=svg
application/vnd.ms-fontobject=eot
application/x-font-woff=woff,woff2
application/x-font-otf=otf
audio/mpeg=mp3,mpeg

[FILEHANDLER]
lua = lua
EOF

docker run \
    -p 8080:80 \
    --mount type=bind,source=/tmp/app,target=/app \
    -e ANTOS_USER=demo \
    -e ANTOS_PASSWORD=demo \
    -it antosaio
```

Here we map the host port 8080 to the port 80 on the `antosaio` container.
From the host browser, the VDE can be accessed via

```
http://localhost:8080
```

### Build your own image
It is really simple to build your own AntOS docker image:

```sh
git clone --depth 1 https://github.com/lxsang/antosaio
cd antosaio
chmod +x bake.sh
sudo ./bake.sh
```

The generated image can be found in `dist`, and will be loaded automatically by docker
