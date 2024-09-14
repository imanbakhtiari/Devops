# Adding Swap Space to a Server

Swap space can be useful for systems with limited RAM, as it provides additional virtual memory. Here's how to add swap space to a server on Ubuntu.

## 1. Check Existing Swap Space

- Open a terminal.
- Check if swap space is currently enabled:

```bash
sudo swapon --show
```

## Create a Swap File
#### Create a swap file of the desired size. For example, to create a 2 GB swap file:

```
sudo fallocate -l 2G /swapfile
```
#### Alternatively, if fallocate is not available, use dd:
```
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
```

## Set Correct Permissions
```
sudo chmod 600 /swapfile
```
## Format the File as Swap
#### Format the file to be used as swap space:
```bash
sudo mkswap /swapfile
```

## Enable the swap file:
```bash
sudo swapon /swapfile
```

## verify
```
sudo swapon --show
```

## Make the Swap File Permanent
#### Edit /etc/fstab
##### Open the /etc/fstab file in a text editor:
```
sudo nano /etc/fstab
```


### Add the following line to make the swap file permanent:
```
/swapfile none swap sw 0 0
```



# Remove Swap Space (Optional)
### To remove the swap file, first turn off swap:
```
sudo swapoff /swapfile
```
### Remove the swap file:
```
sudo rm /swapfile
```
### Remove the entry from /etc/fstab:

## sudo nano /etc/fstab
## Delete or comment out the line related to /swapfile.
