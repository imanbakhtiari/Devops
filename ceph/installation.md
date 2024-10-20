```
sudo apt update
sudo apt install -y curl gnupg lsb-release
```

```
CEPH_RELEASE=18.2.0 # replace this with the active release
curl --silent --remote-name --location https://download.ceph.com/rpm-${CEPH_RELEASE}/el9/noarch/cephadm
```

```
chmod +x cephadm
./cephadm add-repo --release squid
./cephadm install
```

```
which cephadm
```

#### on mng
```
cephadm bootstrap --mon-ip *<mon-ip>*
```

### verify 
```
cephadm shell -- ceph -s
```


```
cephadm add-repo --release squid
cephadm install ceph-common
```
### Confirm that the ceph command is accessible with:
```
ceph -v
```







## To add each new host to the cluster, perform two steps:

### Install the cluster’s public SSH key in the new host’s root user’s authorized_keys file:

```
ssh-copy-id -f -i /etc/ceph/ceph.pub root@*<new-host>*
```
#### For example:
```
ssh-copy-id -f -i /etc/ceph/ceph.pub root@host2
ssh-copy-id -f -i /etc/ceph/ceph.pub root@host3
```
#### Tell Ceph that the new node is part of the cluster:

```
ceph orch host add *<newhost>* [*<ip>*] [*<label1> ...*]
```
#### For example:
```
ceph orch host add host2 10.10.0.102
ceph orch host add host3 10.10.0.103
```


