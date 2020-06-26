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
sudo docker load < antosaoi.tar
```

The image can be run in a container using

```sh
sudo docker run -p 8080:80 -it antosaoi
```

Here we map the host port 8080 to the port 80 on the `antosaoi` container.
From the host browser, the VDE can be accessed via

```
http://localhost:8080/os/
```

Note that: the `/` at the end of the URL is important.

### Build your own image
It is really simple to build your own AntOS docker image:

```sh
git clone --depth 1 https://github.com/lxsang/antosaio
cd antosaio
chmod +x bake.sh
sudo ./bake.sh
```

The generated image can be found in `dist`, and will be loaded automatically by docker
