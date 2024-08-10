## before docker compose  up
```bash
mkdir -p mb/plugins && cd mb
curl -L -o plugins/ch.jar https://github.com/clickhouse/metabase-clickhouse-driver/releases/download/0.9.0/clickhouse.metabase-driver.jar
```

## install

```
sudo docker compose up -d
```

## default user pass clickhouse is username=defaullt password is empty

## you can uncomment line 23 in docker compose and do the following for  custom password

```
mkdir ch_conf
touch ch_conf/users.xml
```
```
cat <<EOF | ./ch_conf/users.xml
<clickhouse>
    <profiles>
        <default>
        </default>
        <readonly>
            <readonly>1</readonly>
        </readonly>
    </profiles>

    <users>
        <default>
            <password>YOUR_PASSWORD_HERE</password>
            <networks>
                <ip>::/0</ip>
            </networks>
            <profile>default</profile>
            <quota>default</quota>
            <access_management>1</access_management>
            <named_collection_control>1</named_collection_control>
        </default>
    </users>

    <quotas>
        <default>
            <interval>
                <duration>3600</duration>
                <queries>0</queries>
                <errors>0</errors>
                <result_rows>0</result_rows>
                <read_rows>0</read_rows>
                <execution_time>0</execution_time>
            </interval>
        </default>
    </quotas>
</clickhouse>
```

### then up the containers
```
sudo docker compose up -d
```
