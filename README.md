# Cipher Bot

Bot Discord autonome de restructuration, modération, sécurité, tickets, rôles, niveaux, rappels et sondages. Il fonctionne séparément de `onepiece-bot` : il utilise son propre token, ses propres données (`data.json`) et son service `cipher-bot`.

Le tableau web intégré reprend les fonctions web du bot : gestion des serveurs autorisés, messages de restructuration, salons temporaires, annonces, rôles, bannissement, inactifs, messages privés de masse avec annulation, restructuration, journaux et paramètres de sécurité.

La version actuelle ajoute également les commandes de modération directes `/ban`, `/kick`, `/warn`, `/seewarn` et `/clearwarn`.

## Déploiement

1. Crée une seconde application/bot dans le portail Discord et active les intents **Server Members** et **Message Content**.
2. Ajoute `https://cipher.lefleau.online/callback` dans les Redirects OAuth2 de cette application.
3. Copie `.env.example` vers `.env`, renseigne uniquement les nouveaux secrets et mets le fichier en permission `600`.
4. Lance les commandes de déploiement ci-dessous.

Ne copie jamais `start.bat`, `data.json` ni les secrets provenant de l'archive d'origine.

## Commandes serveur

Après avoir cloné ce dépôt dans `/home/ubuntu/cipher-bot`, exécute :

```bash
cd /home/ubuntu/cipher-bot
cp .env.example .env
nano .env
bash deploy/setup-server.sh
sudo certbot --nginx -d cipher.lefleau.online
```

Lance ensuite ces contrôles :

```bash
sudo systemctl status cipher-bot --no-pager
sudo journalctl -u cipher-bot -n 100 --no-pager
```
