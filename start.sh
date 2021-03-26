#! /bin/sh
mkdir -p /app/home
if [ -f "/app/file.fs" ]; then
    mount /app/file.fs /app/home
    ls /app
fi
[ ! -e "/home/$ANTOS_USER" ] && ln -sf /app/home "/home/$ANTOS_USER"
adduser --home "/home/$ANTOS_USER" --disabled-password --gecos "" "$ANTOS_USER"
echo -e "$ANTOS_PASSWORD\n$ANTOS_PASSWORD" | passwd "$ANTOS_USER"
# start antd-tunnel service
/usr/bin/antd /app/antd-config.ini &
sleep 1
[ -f /app/runner.ini ] && /opt/www/bin/runner /app/runner.ini &
wait