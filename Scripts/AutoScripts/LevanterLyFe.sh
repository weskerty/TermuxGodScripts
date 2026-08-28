#!/data/data/com.termux/files/usr/bin/bash
G='\e[1;32m'; Y='\e[1;33m'; C='\e[1;36m'; N='\e[0m'

echo -e "${C}┌─────────────────────────────────┐${N}"
echo -e "${C}│ 🚀 Levanter Termux Installer    │${N}"
echo -e "${C}└─────────────────────────────────┘${N}"
echo -e "${Y}ACEPTA LOS PERMISOS CUANDO APAREZCAN | ACCEPT PERMISSIONS WHEN THEY APPEAR${N}"
sleep 3
printf 'y\n' | termux-setup-storage
sleep 7
termux-wake-lock

echo -e "${G}Actualizando repositorios...${N}"
pkg update -y

echo -e "${G}Instalando dependencias...${N}"
apt update -y && yes | apt upgrade && pkg install -y git build-essential clang make pkg-config nano msedit python python-pip nodejs-lts ffmpeg yarn libvips wget p7zip unzip file libxml2 libxslt
pip install cython wheel setuptools python-dotenv
# Python para el Plugin externo DLA que usa yt-dlp, el bot en si no necesita python. libvips por que sharp es una mierda.
# De nuevo, no se cual es la mierda que hace que Sharp falle, asi que agrego paquetes primero, luego NDK

echo -e "${G}Generando node-gyp...${N}"
mkdir -p ~/.gyp
echo "{ 'variables': { 'android_ndk_path': '' } }" > ~/.gyp/include.gypi
grep -q "GYP_DEFINES" ~/.bashrc 2>/dev/null || echo "export GYP_DEFINES=\"android_ndk_path=''\"" >> ~/.bashrc
export GYP_DEFINES="android_ndk_path=''"

echo -e "${G}Instalando PM2...${N}"
yarn global add pm2

echo -e "${G}Instalando Bot...${N}"
if [ -d ~/levanter ]; then
  echo -e "${Y}Levanter ya existe, se reutiliza la carpeta (no se borra database.db ni datos previos).${N}"
else
  git clone --depth 1 https://github.com/lyfe00011/levanter.git ~/levanter || exit 1
fi
cd ~/levanter || exit 1
yarn install

if [ -f config.env ]; then
  echo -e "${Y}config.env ya existe, se conserva (solo se podra actualizar el SESSION_ID).${N}"
else
cat > config.env << 'EOF'
SESSION_ID = ""
SUDO = ""
GROUP_ADMINS = ""
WHITE_LIST = ""
AUTO_UPDATE = "true"
FORCE_LOGOUT = "false"
VPS = "true"
BOT_LANG = "es"
LANGUAG = "es"
DISABLE_START_MESSAGE = "false"
RMBG_KEY = ""
APPROVE = "all"
PREFIX = "."
STICKER_PACKNAME = "by LyFE"
ALWAYS_ONLINE = "true"
WARN_LIMIT = "3"
BRAINSHOP = "159501,6pq8dPiYt7PdqHz3"
MAX_UPLOAD = "1900"
REJECT_CALL = "false"
TZ = "America/Asuncion"
AUTO_STATUS_VIEW = "false"
SEND_READ = "false"
AJOIN = "false"
ANTI_DELETE = "p"
DELETE_TYPE = "all"
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
RESTART_CMD = "pm2 restart levanter"
EOF
fi

echo -e "\e[1;35m¿Tienes tu SESSION_ID? Presiona ${G}N${N} para escanear el QR desde Aqui. Presiona ${G}Y${N} para iniciar sesion desde la Web:${N}"
read -r HAS_SID
if [[ "$HAS_SID" == "y" ]]; then
  termux-open "https://levanter.site/session"
  echo -e "\e[1;35mVe a ${G}levanter.site/session${N} y pega tu SESSION_ID aqui, luego presiona Enter:${N}"
  read -r SID
  sed -i "s|^SESSION_ID = \".*\"|SESSION_ID = \"$SID\"|" config.env
fi

echo -e "${G}Configurando autoinicio...${N}"
cat > ~/.bashrc << 'EOF'
termux-wake-lock
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
cd ~/levanter
yarn start
EOF

echo -e "${G}Iniciando Bot... Plugins Extras Aqui https://levanter.site/plugin ${N}"
yarn start
