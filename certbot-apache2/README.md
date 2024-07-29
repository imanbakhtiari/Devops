```
sudo apt install apache2 apache2-utils certbot python3-certbot-apache
```

```
sudo vi /etc/apache2/sites-available/your_domain.conf
```

```
apachectl configtest
cd /etc/apache2/sites-available/ && a2ensite your_domain.conf
```

```
sudo systemctl reload apache2
```

```
sudo ufw status
sudo ufw allow 'Apache Full'
sudo ufw delete allow 'Apache'
sudo ufw status
```

```
sudo certbot --apache
```

```
sudo systemctl status certbot.timer
sudo certbot renew --dry-run
```
