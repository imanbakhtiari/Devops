```
100 - (avg by (instance) (irate(node_cpu_seconds_total{instance="ip:9100",job="jobname",mode="idle"}[5m])) * 100)
```
