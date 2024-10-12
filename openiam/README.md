## sudo vi /etc/sysctl.conf

```
vm.max_map_count=262144
net.ipv6.conf.all.disable_ipv6=1
net.ipv6.conf.default.disable_ipv6=1
```

### install docker in this link
[docker installation](https://docs.docker.com/engine/install/ubuntu/)


## pre requirements
```
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

## openiam installation
```
mkdir -p /usr/local/openiam
cd /usr/local/openiam
git clone https://bitbucket.org/openiam/openiam-docker-compose.git
cd openiam-docker-compose/
git checkout RELEASE-4.2.1.3
```


```
cd /usr/local/openiam/openiam-docker-compose
sudo ./generate.cert.sh
```

## uncomment this line export IMAGE_SUFFIX="-ce"

```
sudo ./setup.sh
```

##### and after pulling all images run startup.sh

```
sudo ./startup.sh
```

### validate and ensure the startup
```
curl -k -I -L http://127.0.0.1/idp/login
```

##### HTTP/1.1 200 means ok and 
