 CPU Usage
To get CPU usage as a percentage, you can use the node_cpu_seconds_total metric. This metric records the total time the CPU spends in various states (user, system, idle, etc.). You need to calculate the percentage of CPU used over a specific time period.

Example Query for CPU Usage (Overall)
```
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

This query calculates the average idle CPU time over the last 5 minutes and subtracts it from 100% to give you the CPU usage percentage.
2. RAM Usage
To get RAM usage, you can use the node_memory_MemTotal_bytes and node_memory_MemAvailable_bytes metrics.

Example Query for RAM Usage Percentage
```
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
```
This query calculates the percentage of used RAM by subtracting available memory from total memory and dividing by total memory.
3. Disk Usage
For disk usage, you can use the node_filesystem_avail_bytes and node_filesystem_size_bytes metrics. Note that you should filter for the correct mount point (like / for root).

Example Query for Disk Usage Percentage
```
100 * (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}))
```
This query calculates the percentage of used disk space on the root filesystem.
Summary of Queries
CPU Usage:
```
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```
RAM Usage:
```
100 * (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes))
```
Disk Usage:

```
100 * (1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}))
```
