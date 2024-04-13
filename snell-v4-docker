#!/bin/bash

# Cập nhật các gói và nâng cấp hệ thống
apt-get update && apt-get -y upgrade

# Cài đặt Docker
curl -fsSL https://get.docker.com | bash -s docker

# Xác định và gỡ cài đặt các phiên bản khác nhau của Docker Compose
if [ -f "/usr/local/bin/docker-compose" ]; then
    sudo rm /usr/local/bin/docker-compose
fi

if [ -d "$HOME/.docker/cli-plugins/" ]; then
    rm -rf $HOME/.docker/cli-plugins/
fi

# Cài đặt Docker Compose plugin
apt-get install docker-compose-plugin -y

# Tạo các thư mục cần thiết
mkdir -p /root/snelldocker/snell-conf

# Tạo cổng và mật khẩu ngẫu nhiên
RANDOM_PORT=$(shuf -i 30000-65000 -n 1)
RANDOM_PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 20)

# Tạo docker-compose.yml
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
EOF

# Tạo tệp cấu hình snell.conf
cat > /root/snelldocker/snell-conf/snell.conf << EOF
[snell-server]
listen = ::0:$RANDOM_PORT
psk = $RANDOM_PSK
ipv6 = false
EOF

# Chuyển thư mục
cd /root/snelldocker

# Kéo và khởi động vùng chứa Docker
docker compose pull && docker compose up -d

# Lấy địa chỉ IP cục bộ
HOST_IP=$(curl -s http://checkip.amazonaws.com)

# Lấy quốc gia nơi đặt IP
IP_COUNTRY=$(curl -s http://ipinfo.io/$HOST_IP/country)

# Xuất thông tin cần thiết, bao gồm cả quốc gia nơi đặt IP
echo "$IP_COUNTRY = snell, $HOST_IP, $RANDOM_PORT, psk = $RANDOM_PSK, version = 4, reuse = true, tfo = true"
