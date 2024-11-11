```
100 - ((node_filesystem_avail_bytes{job="$job", instance="$instance"} * 100) / node_filesystem_size_bytes{job="$job", instance="$instance"})
```
