```bash
ip -6 addr show
```

```bash
sudo vi /etc/default/grub
```

## for disable
```bash
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=1"
```

## to enable ipv6
```bash
GRUB_CMDLINE_LINUX_DEFAULT="ipv6.disable=0"
```

## update grub to apply configurations

```bash
sudo update-grub
```

```
reboot 
```

```
ip -6 addr show
```
