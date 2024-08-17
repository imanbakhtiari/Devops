# with sysctl
```bash
sudo vi /etc/sysctl.conf
```

```
# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
```
```
sudo sysctl -p
```

```
sudo reboot
```

```
ping6 google.com
```

# with grup
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
