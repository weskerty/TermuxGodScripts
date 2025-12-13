#!/data/data/com.termux/files/usr/bin/bash
SF="$HOME/.sshx_last"
LU=$(sed -n 1p "$SF" 2>/dev/null)
LI=$(sed -n 2p "$SF" 2>/dev/null)
read -p "IP [$LI]: " IP
read -p "User [$LU]: " U
IP=${IP:-$LI}
U=${U:-$LU}
[ -z "$IP" ]||[ -z "$U" ]&&exit 1
printf "%s\n%s" "$U" "$IP" >"$SF"
pkill -f termux.x11 2>/dev/null
pulseaudio -k 2>/dev/null
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
trap 'pulseaudio -k;pkill -f termux.x11' EXIT
export XDG_RUNTIME_DIR=$TMPDIR
termux-x11 :0 >/dev/null &
sleep 3
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1
sleep 1
env DISPLAY=:0 PULSE_SERVER=tcp:127.0.0.1:4714 ssh -Y -L 4714:127.0.0.1:4713 $U@$IP
