#!/bin/bash

# Dừng và xóa vùng chứa Docker
echo "Dừng và xóa vùng chứa Docker..."
cd /root/snelldocker
docker compose down >/dev/null 2>&1
echo "Vùng chứa Docker đã bị dừng và xóa."

# Xóa các tập tin cài đặt và cấu hình
echo "Xóa các tập tin cài đặt và cấu hình..."
rm -rf /root/snelldocker

# Kiểm tra xem Docker đã được cài đặt chưa và gỡ cài đặt nếu cài đặt
if [ -x "$(command -v docker)" ]; then
    echo "Đang gỡ cài đặt Docker..."
    apt-get remove --purge -y docker docker-engine docker.io containerd runc >/dev/null 2>&1
    apt-get autoremove -y >/dev/null 2>&1
    echo "Docker đã được gỡ cài đặt."
else
    echo "Docker chưa được cài đặt, bỏ qua bước gỡ cài đặt."
fi

# Kiểm tra xem plugin Docker Compose đã được cài đặt chưa và gỡ cài đặt nó nếu đã cài đặt
if [ -x "$(command -v docker-compose)" ]; then
    echo "Đang gỡ cài đặt plugin Docker Compose..."
    apt-get remove --purge -y docker-compose-plugin >/dev/null 2>&1
    apt-get autoremove -y >/dev/null 2>&1
    echo "Plugin Docker Compose đã được gỡ cài đặt."
else
    echo "Plug-in Docker Compose chưa được cài đặt, hãy bỏ qua bước gỡ cài đặt."
fi

# Dọn dẹp các tài nguyên Docker không sử dụng
docker system prune -a -f >/dev/null 2>&1

# Hoàn thành
echo "Đã gỡ cài đặt xong."
