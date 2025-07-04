#!/bin/bash

set -e

echo "[1/7] Скачиваем и запускаем оригинальный openvpn-install.sh"
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
./openvpn-install.sh

echo "[2/7] Удаляем openvpn"
apt remove openvpn -y

echo "[3/7] Скачиваем и запускаем openvpn_xor_install.sh"
wget https://raw.githubusercontent.com/x0r2d2/openvpn-xor/main/openvpn_xor_install.sh -O openvpn_xor_install.sh
chmod +x openvpn_xor_install.sh
bash openvpn_xor_install.sh

echo "[4/7] Генерируем пароль"
PASSWORD=$(openssl rand -base64 24)
echo "Сгенерированный пароль: $PASSWORD"

# Формируем строку для добавления
LINE="scramble obfuscate \"$PASSWORD\""

echo "[5/7] Добавляем пароль в /etc/openvpn/server.conf и /etc/openvpn/client-template.txt"
echo "$LINE" >> /etc/openvpn/server.conf
echo "$LINE" >> /etc/openvpn/client-template.txt

echo "[6/7] Готово."

# Спрашиваем у пользователя запускать ли openvpn-install.sh еще раз
while true; do
    read -rp "Для создания нового клиента нужна перезагрузка bash openvpn-install.sh ещё раз? (y/n): " yn
    case $yn in
        [Yy]* ) ./openvpn-install.sh; break;;
        [Nn]* ) echo "Выход."; exit 0;;
        * ) echo "Пожалуйста, ответьте y (да) или n (нет).";;
    esac
done
