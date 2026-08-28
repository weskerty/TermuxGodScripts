#!/data/data/com.termux/files/usr/bin/bash
G='\e[1;32m'; Y='\e[1;33m'; C='\e[1;36m'; N='\e[0m'

echo -e "${C}┌─────────────────────────────────┐${N}"
echo -e "${C}│ 🚀 Levanter Termux Installer    │${N}"
echo -e "${C}└─────────────────────────────────┘${N}"
echo -e "${Y}ACEPTA LOS PERMISOS CUANDO APAREZCAN | ACCEPT PERMISSIONS WHEN THEY APPEAR${N}"
sleep 3
printf 'n\n' | termux-setup-storage
sleep 3
termux-wake-lock

echo -e "${G}Actualizando repositorios...${N}"
pkg update -y && pkg upgrade -y

echo -e "${G}Instalando dependencias...${N}"
pkg install -y python nodejs-lts git ffmpeg yarn build-essential python-pip libxml2 libxslt || exit 1

echo -e "${G}Configurando node-gyp para Termux (sin NDK)...${N}"
mkdir -p ~/.gyp
echo "{ 'variables': { 'android_ndk_path': '' } }" > ~/.gyp/include.gypi
grep -q "GYP_DEFINES" ~/.bashrc 2>/dev/null || echo "export GYP_DEFINES=\"android_ndk_path=''\"" >> ~/.bashrc
export GYP_DEFINES="android_ndk_path=''"

echo -e "${G}Instalando PM2...${N}"
yarn global add pm2

echo -e "${G}Clonando Levanter...${N}"
git clone https://github.com/lyfe00011/levanter.git ~/levanter || exit 1
cd ~/levanter || exit 1

echo -e "${G}Instalando dependencias de Levanter...${N}"
yarn install

cat > config.env << 'EOF'
SESSION_ID = ""
SUDO = ""
FORCE_LOGOUT = "false"
VPS = "true"
DISABLE_START_MESSAGE = "false"
RMBG_KEY = ""
APPROVE = "all"
PREFIX = "."
STICKER_PACKNAME = "by LyFE"
ALWAYS_ONLINE = "true"
WARN_LIMIT = "3"
BRAINSHOP = "159501,6pq8dPiYt7PdqHz3"
MAX_UPLOAD = "1000"
REJECT_CALL = "false"
TZ = "America/Asuncion"
AUTO_STATUS_VIEW = "false"
SEND_READ = "false"
AJOIN = "false"
LIST_TYPE = "list"
CMD_REACTION = "true"
ANTIWORDS = "kill,pilin"
WARN_MESSAGE = "> i _&mention Warn_"
WARN_RESET_MESSAGE = "> i _&mention warn reset_"
WARN_KICK_MESSAGE = "> i _&mention Fuiste Temporalmente Suspendido por incumplir las Normas._"
ANTILINK_MSG = "> i _&mention El Spam no se Tolera Aqui. Respeta las Reglas._"
ANTISPAM_MSG = "> i _&mention Fuiste Temporalmente Suspendido por Flood._"
ANTIWORDS_MSG = "> i _&mention no word"
PERSONAL_MESSAGE = "null"
EOF

echo -e "\e[1;35m¿Tienes tu SESSION_ID? (y/n):${N}"
read -r HAS_SID
if [[ "$HAS_SID" == "y" ]]; then
  echo -e "\e[1;35mPega tu SESSION_ID y presiona Enter:${N}"
  read -r SID
  sed -i "s|SESSION_ID = \"\"|SESSION_ID = \"$SID\"|" config.env
fi

echo -e "${G}Configurando autoinicio...${N}"
cat > ~/.bashrc << 'EOF'
termux-wake-lock
export GYP_DEFINES="android_ndk_path=''"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${YELLOW}Presiona una tecla para evitar el inicio automatico...${NC}"
timeout=5
while [ $timeout -gt 0 ]; do
  echo -ne "${YELLOW}Iniciando en $timeout segundos...\r${NC}"
  read -t 1 -n 1 keypress
  if [ $? -eq 0 ]; then
    echo -e "\n${RED}Inicio automatico cancelado.${NC}"
    echo -e "${GREEN}Puedes usar Termux normalmente.${NC}"
    echo -e "Ir a la carpeta del bot: ${YELLOW}cd levanter${NC}"
    echo -e "Editar config: ${YELLOW}nano config.env${NC} (Ctrl+O guardar, Ctrl+X salir)"
    return 0
  fi
  timeout=$((timeout - 1))
done

echo -e "\n${GREEN}Iniciando Bot...${NC}"
cd ~/levanter && yarn start
EOF

echo -e "${G}Listo. Iniciando bot ahora...${N}"
yarn start
