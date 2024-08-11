## in ubuntu
```
apt-get update && apt-get install -y tzdata
cat /etc/timezone
ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime
echo "Asia/Tehran" > /etc/timezone
```

## verify
```
date +%Z
```

## in alpine
```
apk add --no-cache tzdata
ln -sf /usr/share/zoneinfo/Asia/Tehran /etc/localtime
date
```


