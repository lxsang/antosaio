FROM  ubuntu:focal AS deploy-env
RUN apt-get update && apt-get --yes --no-install-recommends install libsqlite3-0 zlib1g libreadline8 libssl1.1 wget 
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
RUN cp -rf /lib/*-linux-*/libpcre* /ulib
RUN cp -rf /lib/*-linux-*/libuuid* /ulib
RUN cp -rf /lib/*-linux-*/libidn2* /ulib
RUN cp -rf /lib/*-linux-*/libpsl* /ulib
RUN cp -rf /lib/*-linux-*/libunistring* /ulib

FROM  ubuntu:focal AS build-env
RUN apt-get update &&  DEBIAN_FRONTEND="noninteractive" apt-get --yes --no-install-recommends install wget build-essential make libsqlite3-dev zlib1g-dev libreadline-dev libssl-dev
RUN mkdir /download
RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/ant-http/raw/master/dist/antd-1.0.6b.tar.gz \
    && tar xvzf antd-1.0.6b.tar.gz \
    && rm antd-1.0.6b.tar.gz
RUN cd /download/antd-1.0.6b && ./configure --prefix=/usr/  && make && make install

RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/antd-lua-plugin/raw/master/dist/lua-0.5.2b.tar.gz \
    && tar xvzf lua-0.5.2b.tar.gz \
    && rm lua-0.5.2b.tar.gz
RUN cd /download/lua-0.5.2b && ./configure --prefix=/opt/www  && make && make install

RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/antd-wterm-plugin/raw/master/dist/wterm-1.0.0b.tar.gz \
    && tar xvzf wterm-1.0.0b.tar.gz \
    && rm wterm-1.0.0b.tar.gz
RUN cd /download/wterm-1.0.0b && ./configure --prefix=/opt/www  && make && make install

RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/antd-tunnel-plugin/raw/master/dist/tunnel-0.1.0b.tar.gz \
    && tar xvzf tunnel-0.1.0b.tar.gz \
    && rm tunnel-0.1.0b.tar.gz
RUN cd /download/tunnel-0.1.0b && ./configure --prefix=/opt/www  && make && make install

RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/antd-tunnel-publishers/raw/master/dist/antd-publishers-0.1.0a.tar.gz \
    && tar xvzf antd-publishers-0.1.0a.tar.gz \
    && rm antd-publishers-0.1.0a.tar.gz
RUN cd /download/antd-publishers-0.1.0a && ./configure --prefix=/opt/www  && make && make install

# download web apps
RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/antd-web-apps/raw/master/dist/antd_web_apps.tar.gz#nothing3 \
    && mkdir -p  y-antd-web-apps \
    && tar xvzf antd_web_apps.tar.gz -C y-antd-web-apps \
    && rm antd_web_apps.tar.gz

RUN rm -rf /download/z-antos
RUN cd /download \
    && wget --no-check-certificate https://github.com/lxsang/antos/raw/next-1.2.0/release/antos-1.2.0.tar.gz  \
    && mkdir -p z-antos \
    && tar xvzf antos-1.2.0.tar.gz -C z-antos \
    && rm antos-1.2.0.tar.gz

FROM busybox:stable-glibc
#copy all necessary libraries
COPY --from=deploy-env /ulib/* /lib/
COPY --from=deploy-env /bin/wget /bin/ 
COPY --from=build-env /usr/bin/antd /usr/bin/antd
COPY --from=build-env /usr/lib/libantd* /usr/lib/
COPY --from=build-env /opt/www /opt/www
COPY --from=build-env /download/z-antos /opt/www/htdocs/os
COPY --from=build-env /download/y-antd-web-apps/os /opt/www/htdocs/os
COPY --from=build-env /download/y-antd-web-apps/silk /opt/www/htdocs/silk
COPY --from=build-env /download/y-antd-web-apps/mimes.json /opt/www/htdocs/
RUN chown -R root:root /opt/www/htdocs/
COPY start.sh /start.sh
RUN chmod 700 /start.sh
ENTRYPOINT /start.sh
