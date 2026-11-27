#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
APP_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
UNIT_FILE="$(mktemp)"
trap 'rm -f "$UNIT_FILE"' EXIT

cd "$APP_DIR"

if [ ! -f .env ]; then
    echo "Crée et renseigne d'abord $APP_DIR/.env à partir de .env.example."
    exit 1
fi

chmod 600 .env
python3 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt

sed "s|/home/ubuntu/cipher-bot|$APP_DIR|g" deploy/cipher-bot.service > "$UNIT_FILE"
sudo install -m 644 "$UNIT_FILE" /etc/systemd/system/cipher-bot.service
sudo install -m 644 deploy/cipher.lefleau.online.conf /etc/nginx/sites-available/cipher.lefleau.online
sudo ln -sfn /etc/nginx/sites-available/cipher.lefleau.online /etc/nginx/sites-enabled/cipher.lefleau.online
sudo nginx -t
sudo systemctl daemon-reload
sudo systemctl enable --now cipher-bot
sudo systemctl reload nginx

echo "Service Cipher démarré. Termine avec : sudo certbot --nginx -d cipher.lefleau.online"
