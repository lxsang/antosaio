FROM  ubuntu:focal AS build-env

RUN apt-get update &&  DEBIAN_FRONTEND="noninteractive" apt-get --yes --no-install-recommends install build-essential make libsqlite3-dev zlib1g-dev libreadline-dev nodejs npm libssl-dev
COPY download /download
RUN cd /download/antd-1.0.6b && ./configure --prefix=/usr/  && make && make install
RUN cd /download/lua-0.5.2b && ./configure --prefix=/opt/www  && make && make install
RUN cd /download/wterm-1.0.0b && ./configure --prefix=/opt/www  && make && make install

RUN cd /download/tunnel-0.1.0b && ./configure --prefix=/opt/www  && make && make install
RUN cd /download/antd-publishers-0.1.0a && ./configure --prefix=/opt/www  && make && make install


RUN mkdir -p /opt/www/htdocs
RUN cd /download/antd-web-apps && BUILDDIR=/opt/www/htdocs PROJS=os make
RUN rm /opt/www/htdocs/index.ls
RUN npm config set strict-ssl false
RUN cd /download/antos && npm install terser uglifycss typescript -g && npm install @types/jquery && BUILDDIR=/opt/www/htdocs/os make release

FROM  ubuntu:focal AS deploy-env
RUN apt-get update && apt-get --yes --no-install-recommends install libsqlite3-0 zlib1g libreadline8 libssl1.1
RUN apt clean &&  rm -rf /var/lib/apt/lists/*
RUN mkdir /ulib
RUN cp -rf /lib/*-linux-*/libsqlite3* /ulib
RUN cp -rf /lib/*-linux-*/libreadline* /ulib
RUN cp -rf /lib/*-linux-*/libncurse* /ulib
RUN cp -rf /lib/*-linux-*/libz* /ulib
RUN cp -rf /lib/*-linux-*/libcrypt* /ulib
RUN cp -rf /lib/*-linux-*/libdl* /ulib
RUN cp -rf /lib/*-linux-*/libm* /ulib
RUN cp -rf /lib/*-linux-*/libpthread* /ulib
RUN cp -rf /lib/*-linux-*/libssl* /ulib
RUN cp -rf /lib/*-linux-*/libc* /ulib
RUN cp -rf /lib/*-linux-*/libgcc* /ulib
RUN cp -rf /lib/*-linux-*/ld* /ulib

FROM busybox:stable-glibc
#copy all necessary libraries
COPY --from=deploy-env /ulib/* /lib/
COPY --from=build-env /usr/bin/antd /usr/bin/antd
COPY --from=build-env /usr/lib/libantd* /usr/lib/
COPY --from=build-env /opt/www /opt/www
COPY start.sh /start.sh
RUN chmod 700 /start.sh
ENTRYPOINT /start.sh
