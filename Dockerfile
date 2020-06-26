FROM alpine AS build-env
RUN apk add build-base make sqlite-dev zlib-dev readline-dev nodejs npm
COPY download /download
RUN cd /download/antd-1.0.4b && ./configure --prefix=/usr/ --enable-debug=yes && make && make install
RUN cd /download/lua-0.5.2b && ./configure --prefix=/opt/www --enable-debug=yes && make && make install
RUN cd /download/wterm-1.0.0b && ./configure --prefix=/opt/www --enable-debug=yes && make && make install
RUN mkdir -p /opt/www/htdocs
RUN cd /download/antd-web-apps && BUILDDIR=/opt/www/htdocs PROJS=os make
RUN rm /opt/www/htdocs/index.ls
RUN cd /download/antos && npm install terser uglifycss typescript -g && npm install @types/jquery && BUILDDIR=/opt/www/htdocs/os make release

FROM alpine
RUN apk add --no-cache sqlite-dev zlib readline-dev

COPY antd-config.ini /etc/antd-config.ini
COPY --from=build-env /usr/bin/antd /usr/bin/antd
COPY --from=build-env /usr/lib/libantd* /usr/lib/
COPY --from=build-env /opt/www /opt/www
RUN adduser --home /home/demo --disabled-password --gecos "" demo
RUN echo -e "demo\ndemo" | passwd demo
ENTRYPOINT LD_PRELOAD=/opt/www/lib/lua/core.so /usr/bin/antd /etc/antd-config.ini