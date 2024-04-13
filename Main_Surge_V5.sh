#!/bin/bash

echo "----------------Chào mừng đến với surge docker--------------------"
echo "1，Cài đặt bằng một cú nhấp chuột snell-v4 shadow-tls v3"
echo "2，Cài đặt bằng một cú nhấp chuột snell-v4"
echo "3，Gỡ cài đặt bằng một cú nhấp chuột (sẽ gỡ cài đặt toàn bộ vùng chứa), hãy thận trọng khi sử dụng trừ khi bạn biết mình đang làm gì."
echo "4，Cài đặt Hysteria2 chỉ bằng một cú nhấp chuột"
read -p "Vui lòng chọn một hành động (1, 2, 3 hoặc 4）: " user_choice

case $user_choice in
1)
    echo "Đang cài đặt snell-v4 shadow-tls v3..."
    wget https://raw.githubusercontent.com/finish475/main-surge-v4/main/snell-stls.sh -O snell-stls.sh
    chmod +x snell-stls.sh
    ./snell-stls.sh
    ;;
2)
    echo "Đang cài đặt snell-v4..."
    wget https://raw.githubusercontent.com/finish475/main-surge-v4/main/snell-v4-docker.sh -O snell-v4-docker.sh
    chmod +x snell-v4-docker.sh
    ./snell-v4-docker.sh
    ;;
3)
    echo "Gỡ cài đặt snell-v4 shadow-tls v3..."
    wget https://raw.githubusercontent.com/finish475/main-surge-v4/main/uninstall_snell_with_tls.sh -O uninstall_snell_with_tls.sh
    chmod +x uninstall_snell_with_tls.sh
    ./uninstall_snell_with_tls.sh
    ;;
4)
    echo "Đang cài đặt hy2..."
    wget https://raw.githubusercontent.com/finish475/main-surge-v4/main/hy2.sh -O hy2.sh
    chmod +x hy2.sh
    ./hy2.sh
    ;;
*)
    echo "Đầu vào không hợp lệ, tập lệnh thoát."
    exit 1
    ;;
esac
