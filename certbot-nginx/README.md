```
sudo apt install nginx certbot python3-certbot-nginx
```

```
sudo vi /etc/nginx/sites-available/domain.com
```

```
sudo nginx -t
```

```
sudo systemctl reload nginx
```

```
sudo ufw status
sudo ufw allow 'Nginx Full'
sudo ufw delete allow 'Nginx HTTP'
sudo ufw status
```

```
sudo certbot --nginx -d example.com -d www.example.com
```

## for auto-renewal
```
sudo certbot renew --dry-run
sudo systemctl status certbot.timer
```
