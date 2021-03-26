#! /bin/sh
mkdir -p /app/data
if [ -f "/app/file.fs" ]; then
    mount /app/file.fs /app/data
fi
mkdir -p /app/data/home
mkdir -p /app/data/database
mkdir -p /app/data/tmp
[ ! -e "/home/$ANTOS_USER" ] && ln -sf /app/data/home "/home/$ANTOS_USER"
adduser --home "/home/$ANTOS_USER" --disabled-password --gecos "" "$ANTOS_USER"
echo -e "$ANTOS_PASSWORD\n$ANTOS_PASSWORD" | passwd "$ANTOS_USER"
# start antd-tunnel service
/usr/bin/antd /app/antd-config.ini &
sleep 1
[ -f /app/runner.ini ] && /opt/www/bin/runner /app/runner.ini &
wait