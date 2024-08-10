## before docker compose  up
```bash
mkdir -p mb/plugins && cd mb
curl -L -o plugins/ch.jar https://github.com/clickhouse/metabase-clickhouse-driver/releases/download/0.9.0/clickhouse.metabase-driver.jar
```

## install

```
sudo docker compose up -d
```

