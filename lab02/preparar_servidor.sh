#!/usr/bin/env bash
# preparar_servidor.sh - Deja el servidor de la U.E. Horizonte listo para los proximos laboratorios.
# Uso:  sudo bash preparar_servidor.sh <tu_usuario>
# Meta: que sea IDEMPOTENTE (ejecutarlo 2 veces no rompe nada).
set -euo pipefail

USUARIO="${1:-}"
if [[ $EUID -ne 0 ]]; then echo "Ejecuta con sudo: sudo bash $0 <usuario>"; exit 1; fi
if [[ -z "$USUARIO" ]]; then echo "Falta el usuario: sudo bash $0 <usuario>"; exit 1; fi

paso() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

paso "1. Nombre del servidor y zona horaria"
hostnamectl set-hostname srv-horizonte 2>/dev/null || echo srv-horizonte > /etc/hostname
timedatectl set-timezone America/La_Paz

paso "2. Paquetes base"
apt-get update -qq
apt-get install -y curl htop tree ufw unattended-upgrades

paso "3. Usuario administrador con sudo"
if ! id "$USUARIO" &>/dev/null; then
  adduser --disabled-password --gecos "Administrador Horizonte" "$USUARIO"
fi
# Sin la -a, usermod REEMPLAZA los grupos secundarios.
usermod -aG sudo "$USUARIO"

paso "4. Grupo webadmin y carpeta del sitio"
getent group webadmin >/dev/null || groupadd webadmin
usermod -aG webadmin "$USUARIO"
install -d -o root -g webadmin -m 2775 /srv/horizonte/www /srv/horizonte/portal
[[ -f /srv/horizonte/www/index.html ]] || echo '<h1>U.E. Horizonte</h1>' > /srv/horizonte/www/index.html

paso "5. Nombres locales (hasta que tengamos DNS propio en la clase 7)"
for nombre in www.horizonte.internal portal.horizonte.internal; do
  grep -q " $nombre" /etc/hosts || echo "127.0.1.1 $nombre" >> /etc/hosts
done

paso "6. Servicio SSH habilitado y activo"
systemctl enable --now ssh

paso "Resumen"
echo "Usuario: $USUARIO  ->  grupos: $(id -nG "$USUARIO")"
ls -ld /srv/horizonte /srv/horizonte/www 2>/dev/null || echo "Aun no existe /srv/horizonte"
systemctl is-active ssh || true
