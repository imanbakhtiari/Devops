```
prometheus['listen_address'] = '0.0.0.0:9090'

# Enable Prometheus
prometheus['enable'] = true

# Enable GitLab metrics
gitlab_exporter['enable'] = true

# Enable Redis metrics
redis_exporter['enable'] = true

# Enable Postgres metrics
postgres_exporter['enable'] = true

# Enable Node Exporter metrics
node_exporter['enable'] = true

prometheus_monitoring['enable'] = false

sidekiq['metrics_enabled'] = false

# Already set to `false` by default, but you can explicitly disable it to be sure
puma['exporter_enabled'] = false
```
