- for cpu
```
top -bn1 | awk '/Cpu\(s\)/ {print "CPU Used: " 100 - $8 "%"}'
```

- for ram
```
free | awk '/Mem:/ {printf("RAM Used: %.2f%%\n", $3/$2 * 100)}'
```
