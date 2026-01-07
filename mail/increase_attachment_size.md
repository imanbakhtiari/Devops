```bash
sudo vim /opt/www/roundcubemail/config/config.inc.php
```
- change the $config['max_message_size'] = '35M';

```bash
sudo postconf -e "message_size_limit = 20971520"
```

```bash
sudo systemctl restart postfix nginx
```
