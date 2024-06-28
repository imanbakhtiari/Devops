```
sudo pvcreate /dev/sdbX 
```
```
sudo vgextend ubuntu-vg /dev/sdbX
```
```
sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv -r
```

## if you forget -r do the following


## THEN
## For ext4 filesystem:
```
sudo resize2fs /dev/ubuntu-vg/ubuntu-lv
```
## For XFS filesystem:
```
sudo xfs_growfs /dev/ubuntu-vg/ubuntu-lv
```
