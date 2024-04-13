#!/bin/bash

# Dừng cấu hình vùng chứa Docker hiện tại
cd /root/snelldocker
docker compose down

# Cập nhật các gói và nâng cấp hệ thống
apt-get update && apt-get -y upgrade

# Cài đặt Docker
curl -fsSL https://get.docker.com | bash -s docker

# Xác định và gỡ cài đặt các phiên bản khác nhau Docker Compose
if [ -f "/usr/local/bin/docker-compose" ]; then
    sudo rm /usr/local/bin/docker-compose
fi

if [ -d "$HOME/.docker/cli-plugins/" ]; then
    rm -rf $HOME/.docker/cli-plugins/
fi

# Cài đặt Docker Compose plugin
apt-get install docker-compose-plugin -y

# Đảm bảo thư mục cần thiết tồn tại
mkdir -p /root/snelldocker/snell-conf

# Tạo cổng và mật khẩu ngẫu nhiên
RANDOM_PORT=$(shuf -i 30000-65000 -n 1)
RANDOM_PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20) # mật khẩu ngẫu nhiên của snell
RANDOM_SHADOW_TLS_PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 10) # Mật khẩu ngẫu nhiên cho Shadow-tls

# Tạo tệp cấu hình docker-compose.yml và snell.conf
cat > /root/snelldocker/docker-compose.yml << EOF
version: "3.8"
services:
  snell:
    image: accors/snell:latest
    container_name: snell
    restart: always
    network_mode: host
    volumes:
      - ./snell-conf/snell.conf:/etc/snell-server.conf
    environment:
      - SNELL_URL=https://dl.nssurge.com/snell/snell-server-v4.0.1-linux-amd64.zip
  shadow-tls:
    image: ghcr.io/ihciah/shadow-tls:latest
    container_name: shadow-tls
    restart: always
    network_mode: "host"
    environment:
      - MODE=server
      - V3=1
      - LISTEN=0.0.0.0:8443
      - SERVER=127.0.0.1:$RANDOM_PORT
      - TLS=m.tiktok.com:443
      - PASSWORD=$RANDOM_SHADOW_TLS_PSK
EOF

cat > /root/snelldocker/snell-conf/snell.conf << EOF
[snell-server]
listen = ::0:$RANDOM_PORT
psk = $RANDOM_PSK
ipv6 = false
EOF

# Kéo hình ảnh Docker mới nhất và khởi động vùng chứa
cd /root/snelldocker
docker compose pull && docker compose up -d

# Nhận địa chỉ IP Puplic và quốc gia nơi đặt IP
HOST_IP=$(curl -s http://checkip.amazonaws.com)
IP_COUNTRY=$(curl -s http://ipinfo.io/$HOST_IP/country)

# Xuất thông tin cần thiết, bao gồm cả quốc gia nơi đặt IP
echo "$IP_COUNTRY = snell, $HOST_IP, 8443, psk = $RANDOM_PSK, version = 4, reuse = true, tfo = true, shadow-tls-password=$RANDOM_SHADOW_TLS_PSK, shadow-tls-sni=m.tiktok.com, shadow-tls-version=3"
echo "Vui lòng cho phép cổng tường lửa 8443,$RANDOM_PORT"
