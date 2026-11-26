#!/usr/bin/env bash
set -euo pipefail

APP_DIR=/home/ubuntu/cipher-bot

cd "$APP_DIR"

if [ ! -f .env ]; then
    echo "Crée et renseigne d'abord $APP_DIR/.env à partir de .env.example."
    exit 1
fi

chmod 600 .env
python3 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt

sudo install -m 644 deploy/cipher-bot.service /etc/systemd/system/cipher-bot.service
sudo install -m 644 deploy/cipher.lefleau.online.conf /etc/nginx/sites-available/cipher.lefleau.online
sudo ln -sfn /etc/nginx/sites-available/cipher.lefleau.online /etc/nginx/sites-enabled/cipher.lefleau.online
sudo nginx -t
sudo systemctl daemon-reload
sudo systemctl enable --now cipher-bot
sudo systemctl reload nginx

echo "Service Cipher démarré. Termine avec : sudo certbot --nginx -d cipher.lefleau.online"
