#!/data/data/com.termux/files/usr/bin/bash
pkg i -y tur-repo x11-repo
apt update -y&&yes|apt upgrade
pkg i -y xfce termux-x11-nightly pulseaudio wget mesa-vulkan-icd-freedreno
D1="$HOME/.config/pip";F1="$D1/pip.conf"
mkdir -p "$D1"
grep -q termux-user-repository "$F1" 2>/dev/null||cat>>"$F1"<<'EOF'
[install]
extra-index-url = https://termux-user-repository.github.io/pypi/
EOF

printf 'y\y'|termux-setup-storage
sleep 5
while true; do
    if [ -d ~/storage/shared ]; then
        break
    else
        printf '\033[33mSTORAGE PERMISSION DENIED 😐 \033[0m\n'
    fi
    sleep 3
done
mkdir ~/storage/shared/Download/Termux
cd~/storage/shared/Download/Termux
wget https://github.com/termux/termux-x11/releases/latest/download/app-universal-debug.apk

termux-open ~/storage/shared/Download/Termux/app-universal-debug.apk

sleep 30


cd $HOME

U1="https://raw.githubusercontent.com/weskerty/TermuxGod/refs/heads/main/Scripts/Otros/startxfce.sh";D1="$HOME/scripts";N1="$(basename "$U1")";B1="${N1%.*}";A1="t$(echo "$B1" | tr '[:upper:]' '[:lower:]')";F1="$D1/$N1";mkdir -p "$D1"&&curl -fsSL "$U1" -o "$F1"&&chmod +x "$F1"&&grep -qxF "alias $A1='sh $F1'" "$HOME/.zshrc"||echo "alias $A1='sh $F1'" >>"$HOME/.zshrc"&&sh "$F1"

printf '\033[33mRun: tstartxfce\033[0m\n'

