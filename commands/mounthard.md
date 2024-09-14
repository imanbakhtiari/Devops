# Mounting an External Hard Drive on Ubuntu

## 1. Connect the External Hard Drive

- Plug the external hard drive into a USB port on your Ubuntu server.

## 2. Identify the Drive

- Open a terminal.
- List the available storage devices and partitions:

```bash
lsblk
```

## Get the UUID of the drive:
```
sudo blkid
```

## Create a Mount Point
#### Create a directory where you want to mount the external hard drive:

```
sudo mkdir /mnt/myexternaldrive
```

##  Mount the Drive
#### Mount the drive to the directory you created:

```
sudo mount /dev/sdX1 /mnt/myexternaldrive
```
##### Replace /dev/sdX1 with your actual device identifier (e.g., /dev/sdb1).

## Auto-Mount After Reboot
#### Edit /etc/fstab
#### Open the /etc/fstab file in a text editor:

```
sudo nano /etc/fstab
```

#### Add an entry for your external drive:

```
UUID=your-drive-uuid /mnt/myexternaldrive file_system_type defaults 0 2
```

#### Replace:

##### your-drive-uuid with the actual UUID of your partition.
##### /mnt/myexternaldrive with your mount point.
##### file_system_type with the type of file system (e.g., ext4, ntfs, vfat).

## Example:
```
UUID=1234-5678 /mnt/myexternaldrive ext4 defaults 0 2
```

## Test the Configuration
#### Test the /etc/fstab configuration without rebooting:
```bash
sudo mount -a
ls /mnt/myexternaldrive
```







