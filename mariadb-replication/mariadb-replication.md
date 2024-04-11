## Mariadb Replication in three nodes
#### first install mariadb in all three nodes 
```bash
sudo apt install mariadb-server
```

## **on master node /etc/mysql/mariadb.cnf** (do not need to mentionn that you have to restart mariadb server after changing its configuration)

```bash
[mariadb]
bind-address = 0.0.0.0
server-id = 10
log_bin = mysql-bin
```
#### login to mariadb with
```bash
mariadb -u root -p
```
#### then create replica user 
```bash
CREATE USER 'replica'@'%' IDENTIFIED BY 'replicapass';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%';
FLUSH PRIVILEGES;
```
#### then you have to see master status for connecting replica nodes to your master 
#### remember that  file and position values are important for slave nodes
```bash
SHOW MASTER STATUS\G;
```
## ** on two  other slave nodes add the following to the end of /etc/mysql/mariadb.cnf** and restart mariadb service 
```bash
[mariadb]
bind-address           = 0.0.0.0
server-id              = 20
log_bin                = mysql-bin
```
#### then login to database and add  these
```bash
CHANGE MASTER TO
MASTER_HOST='IP_OF_MASTER',
MASTER_USER='replica',
MASTER_PASSWORD='replicapass',
MASTER_LOG_FILE='mysql-bin.000005', #### change it according to master status
MASTER_LOG_POS=870;  #### change it according to master status
```
#### and then run
```bash
SHOW SLAVE STATUS\G;
```
### after that you have two see this output to make sure it's working
```bash
Slave_SQL_Running_State: Slave has read all relay log; waiting for the slave I/O thread to update it
Slave_IO_Running: Yes
Slave_SQL_Running: Yes
Slave_IO_State: Waiting for master to send event
```
#### then you can create database in master and see in replica nodes
### READ THIS TOO
#### remember that your previous data won't be in slave nodes and you have to restore backup in slave and then make them to replicate to the master node (because mariadb replication support only change events from when slave connected)
