```
(1 - (node_memory_MemAvailable_bytes{instance="ip:9100",job="jobname"} / node_memory_MemTotal_bytes{instance="ip:9100",job="jobname"})) * 100
```
