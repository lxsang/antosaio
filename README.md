# antosaio

Docker image layer for All-in-one AntOS VDE system.
This layer allows to build a minimal docker image with an
out-of-the-box working AntOS system:

- The web-server (HTTP only) on port 80
- AntOS server side API
- AntOS client side API

The docker images available at: [https://hub.docker.com/r/xsangle/antosaio/](https://hub.docker.com/r/xsangle/antosaio/)

## How it works ?
The following manual requires docker to be installed on the host system.

The image can be run in a container with the following steps

```sh

# app dir that will be mounted to the container
# the server configuration is stored in this location
mkdir -p /tmp/app/{home,tmp,database}

# create the server configuration
cat << EOF > /tmp/app/antd-config.ini
[SERVER]
plugins=/opt/www/lib/
plugins_ext=.so
database=/app/data/database/
tmpdir=/app/data/tmp/
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

# run the container

docker run \
    -p 8080:80 \
    --mount type=bind,source=/tmp/app,target=/app \
    -e ANTOS_USER=demo \
    -e ANTOS_PASSWORD=demo \
    -it xsangle/antosaio:latest
```

From the host browser, the VDE can be accessed via

```
http://localhost:8080
```

### Build the image

The build support support multi-arch build with docker **buildx** plugin. Instruction to install buildx can be found here: [# https://github.com/docker/buildx#installing
](https://github.com/docker/buildx#installing
).

The following architectures are supported: armv7, amd64 and arm64.

After installing the plugin, execute the following commands before running the build script:

```sh
docker buildx create --use
# Register Arm executables to run on x64 machines
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 
```

Clone the repository and run the build script:

```sh
git clone --depth 1 https://github.com/lxsang/antosaio
cd antosaio
chmod +x bake.sh
./bake.sh
```
