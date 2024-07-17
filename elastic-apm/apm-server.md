## server installation to open 8200 port
```
curl -L -O https://artifacts.elastic.co/downloads/apm-server/apm-server-8.2.0-amd64.deb
```
```
sudo dpkg -i apm-server-8.2.0-amd64.deb
```
## If you're using an X-Pack secured version of Elastic Stack, you must specify credentials in the /etc/apm-server/apm-server.yml config file.

```
output.elasticsearch:
    hosts: ["<es_url>"]
    username: <username>
    password: <password>
```

```
sudo service apm-server start
```

## clients are according to your programming languages are diffrent
