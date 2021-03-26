FROM  alpine:3.9 AS build-env

RUN apk add build-base make sqlite-dev zlib-dev readline-dev nodejs npm openssl-dev
COPY download /download
RUN cd /download/antd-1.0.6b && ./configure --prefix=/usr/  && make && make install
RUN cd /download/lua-0.5.2b && ./configure --prefix=/opt/www  && make && make install
RUN cd /download/wterm-1.0.0b && ./configure --prefix=/opt/www  && make && make install

RUN cd /download/tunnel-0.1.0b && ./configure --prefix=/opt/www  && make && make install
RUN cd /download/antd-publishers-0.1.0a && ./configure --prefix=/opt/www  && make && make install


RUN mkdir -p /opt/www/htdocs
RUN cd /download/antd-web-apps && BUILDDIR=/opt/www/htdocs PROJS=os make
RUN rm /opt/www/htdocs/index.ls
RUN cd /download/antos && npm install terser uglifycss typescript -g && npm install @types/jquery && BUILDDIR=/opt/www/htdocs/os make release

FROM alpine:3.9
RUN apk add --no-cache sqlite-dev zlib readline openssl curl

COPY start.sh /start.sh
RUN chmod 700 /start.sh
COPY --from=build-env /usr/bin/antd /usr/bin/antd
COPY --from=build-env /usr/lib/libantd* /usr/lib/
COPY --from=build-env /opt/www /opt/www
ENTRYPOINT /start.sh
# ENTRYPOINT /bin/sh
