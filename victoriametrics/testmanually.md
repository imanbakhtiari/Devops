- in vminsert

```bash
curl -X POST http://127.0.0.1:8480/insert/0/prometheus/api/v1/import/prometheus \
     -H 'Content-Type: text/plain' \
     --data-binary 'icmp_success{job="testprobe", instance="test-node", target="8.8.8.8"} 95 1713877285'
```


- and in vmselect query it
```bash
curl -G 'http://127.0.0.1:8481/select/0/prometheus/api/v1/query' \
     --data-urlencode 'query=icmp_success{job="testprobe",instance="test-node",target="8.8.8.8"}' \
     --data-urlencode 'time=1713877285'
```

