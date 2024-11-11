## For 95% usage of cpu
```
stress-ng --cpu 0 --cpu-method all --cpu-load 95 --timeout 120s --metrics-brief
```

## For 95% usage of ram
```
stress-ng --vm 4 --vm-bytes 95% --vm-method all --timeout 120s --metrics-brief
```
