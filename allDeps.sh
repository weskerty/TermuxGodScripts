#!/data/data/com.termux/files/usr/bin/bash
echo "\e[1;33m⚠️ ACEPTA LOS PERMISOS CUANDO APAREZCAN \e[0m"
echo "\e[1;33m⚠️ CONCEDE PERMISOS DE ALMACENAMIENTO Y EJECUCION \e[0m"
sleep 5
printf 'n\n' | termux-setup-storage
sleep 7
termux-wake-lock
apt-get update
pkg i -y tur-repo x11-repo
apt update -y && yes | apt upgrade && pkg install -y android-tools ano clang make git ffmpeg nodejs-lts pkg-config libxml2 libxslt matplotlib xorgproto rust binutils wget build-essential libvips python-pip glib termux-services termux-api termux-x11-nightly
pip install cython wheel setuptools python-dotenv

echo "\e[1;33m Finalizado \e[0m"
