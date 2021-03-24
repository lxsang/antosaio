#! /bin/sh
ln -sf /app/home "/home/$ANTOS_USER"
adduser --home "/home/$ANTOS_USER" --disabled-password --gecos "" "$ANTOS_USER"
echo -e "$ANTOS_PASSWORD\n$ANTOS_PASSWORD" | passwd "$ANTOS_USER"
# start antd-tunnel service
[ -f /app/runner.ini ] && /opt/www/bin/runner /app/runner.ini &
/usr/bin/antd /app/antd-config.ini