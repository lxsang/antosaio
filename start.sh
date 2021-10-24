#! /bin/sh
mkdir -p /app/data
if [ -f "/app/file.fs" ]; then
    mount /app/file.fs /app/data
fi
mkdir -p /app/data/home
mkdir -p /app/data/database
mkdir -p /app/data/tmp
ln -sf /app/data/tmp /opt/www/tmp
[ ! -e "/home/$ANTOS_USER" ] && ln -sf /app/data/home "/home/$ANTOS_USER"
adduser --home "/home/$ANTOS_USER" --disabled-password --gecos "" "$ANTOS_USER"
echo "$ANTOS_USER:$ANTOS_PASSWORD" | /bin/chpasswd
# start antd-tunnel service
/usr/bin/antd /app/antd-config.ini &
sleep 1
[ -f /app/runner.ini ] && /opt/www/bin/runner /app/runner.ini &
wait