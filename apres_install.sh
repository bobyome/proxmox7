#!/usr/bin/env bash -ex
set -euo pipefail
shopt -s inherit_errexit nullglob
YW=$(echo "\033[33m")
BL=$(echo "\033[36m")
RD=$(echo "\033[01;31m")
BGN=$(echo "\033[4;92m")
GN=$(echo "\033[1;92m")
DGN=$(echo "\033[32m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"
clear
echo -e "${BL}Ce script finalise l'installation de PVE7.${CL}"
echo -e "${BL}Ce script est la version francisé du script de tteckster.${CL}"
echo -e "${BL}Script original disponible à l'adresse : https://https://github.com/tteck${CL}"
echo -e "${BL}Merci à lui pour ce travail magnifique${CL}"
echo -e "****************************************************"
while true; do
    read -p "Lancer l'installation du Script (o/n)?" on
    case $on in
    [Oo]*) break ;;
    [Nn]*) exit ;;
    *) echo "Répondre par Oui ou Non." ;;
    esac
done

if ! command -v pveversion >/dev/null 2>&1; then
    echo -e "\n🛑  Pas de PVE Detecter, Erreur de Script!\n"
    exit 1
fi

if [ $(pveversion | grep "pve-manager/7" | wc -l) -ne 1 ]; then
    echo -e "\n${RD}⚠ Cette version de Proxmox Virtual Environment n'est pas supportée"
    echo -e "Uniquement PVE Version: 7.XX${CL}"
    echo -e "\nExiting..."
    sleep 3
    exit
fi
function header_info {
    echo -e "${RD}
    ____ _    _____________   ____             __     ____           __        ____
   / __ \ |  / / ____/__  /  / __ \____  _____/ /_   /  _/___  _____/ /_____ _/ / /
  / /_/ / | / / __/    / /  / /_/ / __ \/ ___/ __/   / // __ \/ ___/ __/ __  / / / 
 / ____/| |/ / /___   / /  / ____/ /_/ (__  ) /_   _/ // / / (__  ) /_/ /_/ / / /  
/_/     |___/_____/  /_/  /_/    \____/____/\__/  /___/_/ /_/____/\__/\__,_/_/_/   
${CL}"
}

function msg_info() {
    local msg="$1"
    echo -ne " ${HOLD} ${YW}${msg}..."
}

function msg_ok() {
    local msg="$1"
    echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

clear
header_info
read -r -p "Désactiver les dépots Enterprise? <o/N> " prompt
if [[ $prompt == "o" || $prompt == "O" || $prompt == "oui" || $prompt == "Oui" ]]; then
    msg_info "Traitement en cours"
    sleep 2
    sed -i "s/^deb/#deb/g" /etc/apt/sources.list.d/pve-enterprise.list
    msg_ok "Terminé....."
fi

read -r -p "Ajouter/Corriger les sources pour PVE7 (sources.list)? <o/N> " prompt
if [[ $prompt == "o" || $prompt == "O" || $prompt == "oui" || $prompt == "Oui" ]]; then
    msg_info "Traitement en cours"
    cat <<EOF >/etc/apt/sources.list
deb http://ftp.debian.org/debian bullseye main contrib
deb http://ftp.debian.org/debian bullseye-updates main contrib
deb http://security.debian.org/debian-security bullseye-security main contrib
EOF
    sleep 2
    msg_ok "Terminé....."
fi

read -r -p "Activer dépot No-Subscription ? <o/N> " prompt
if [[ $prompt == "o" || $prompt == "O" || $prompt == "oui" || $prompt == "Oui" ]]; then
    msg_info "Traitement en cours"
    cat <<EOF >>/etc/apt/sources.list
deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription
EOF
    sleep 2
    msg_ok "Terminé....."
fi

read -r -p "Désactive l'affichage Subscription ? <o/N> " prompt
if [[ $prompt == "o" || $prompt == "O" || $prompt == "oui" || $prompt == "Oui" ]]; then
    msg_info "Traitement en cours"
    echo "DPkg::Post-Invoke { \"dpkg -V proxmox-widget-toolkit | grep -q '/proxmoxlib\.js$'; if [ \$? -eq 1 ]; then { echo 'Removing subscription nag from UI...'; sed -i '/data.status/{s/\!//;s/Active/NoMoreNagging/}' /usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js; }; fi\"; };" >/etc/apt/apt.conf.d/no-nag-script
    apt --reinstall install proxmox-widget-toolkit &>/dev/null
    msg_ok "Terminé.....(Vider le cache de votre navigateur)"
fi

read -r -p "Mettre à jour Proxmox VE 7 ? <o/N> " prompt
if [[ $prompt == "o" || $prompt == "O" || $prompt == "oui" || $prompt == "Oui" ]]; then
    msg_info "Traitement en cours...(patience, c'est long)"
    apt-get update &>/dev/null
    apt-get -y dist-upgrade &>/dev/null
    msg_ok "Terminé..... (⚠ Redémarrer le serveur)"
fi

read -r -p "Redémarrer Proxmox VE 7maintenant? <o/N> " prompt
if [[ $prompt == "o" || $prompt == "Y" || $prompt == "oui" || $prompt == "Oui" ]]; then
    msg_info "le serveur va redémarrer"
    sleep 2
    msg_ok "Post Installation terminée"
    reboot
fi

sleep 2
msg_ok "Post Installation terminée"
