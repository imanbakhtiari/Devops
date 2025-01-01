# Setting Up a Galera MySQL Cluster

This guide provides step-by-step instructions for installing and configuring a Galera MySQL cluster. It assumes you are using three nodes for high availability, although a two-node cluster can also work with a Galera Arbitrator (garbd).

---

## Prerequisites

1. **Server Setup:**
   - Minimum 2 nodes (3 recommended).
   - Each server should have a static IP.

2. **System Requirements:**
   - Linux distribution: Ubuntu 20.04/22.04 or CentOS 7/8.
   - MariaDB 10.5+ (includes Galera support).

3. **Firewall Configuration:**
   Open the following ports on all nodes:
   - `3306`: MySQL client connections.
   - `4567`: Galera replication traffic.
   - `4568`: Incremental State Transfer (IST).
   - `4444`: State Snapshot Transfer (SST).

   ```bash
   sudo ufw allow 3306/tcp
   sudo ufw allow 4567/tcp
   sudo ufw allow 4568/tcp
   sudo ufw allow 4444/tcp
   ```

---

## Step 1: Install MariaDB with Galera

### For Ubuntu

1. Add the MariaDB repository:
   ```bash
   sudo apt update
   sudo apt install -y software-properties-common
   sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
   sudo add-apt-repository 'deb [arch=amd64] http://mirror.23media.com/mariadb/repo/10.5/ubuntu focal main'
   ```

2. Install MariaDB:
   ```bash
   sudo apt update
   sudo apt install -y mariadb-server mariadb-client galera-4
   ```

### For CentOS

1. Add the MariaDB repository:
   ```bash
   sudo vi /etc/yum.repos.d/MariaDB.repo
   ```
   Add the following content:
   ```plaintext
   [mariadb]
   name = MariaDB
   baseurl = http://yum.mariadb.org/10.5/centos7-amd64
   gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
   gpgcheck=1
   ```

2. Install MariaDB:
   ```bash
   sudo yum install -y MariaDB-server MariaDB-client galera-4
   ```

3. Start and enable MariaDB:
   ```bash
   sudo systemctl enable --now mariadb
   ```

---

## Step 2: Configure Galera Cluster

### On All Nodes

1. Open the MariaDB configuration file:
   ```bash
   sudo vi /etc/mysql/my.cnf
   # Or for CentOS:
   sudo vi /etc/my.cnf.d/server.cnf
   ```

2. Add or modify the following configuration under `[mysqld]`:
   ```plaintext
   [mysqld]
   bind-address=0.0.0.0
   wsrep_on=ON
   wsrep_provider=/usr/lib/galera/libgalera_smm.so
   wsrep_cluster_name="galera_cluster"
   wsrep_cluster_address="gcomm://NODE1_IP,NODE2_IP,NODE3_IP"
   wsrep_node_address="NODE_IP"  # Replace with this node's IP
   wsrep_node_name="NODE_NAME"   # Replace with a unique name for this node
   wsrep_sst_method=rsync
   default_storage_engine=InnoDB
   innodb_autoinc_lock_mode=2
   ```

3. Save and close the file.

---

## Step 3: Start the Cluster

### Bootstrap the First Node

1. On the first node, stop MySQL and start it in bootstrap mode:
   ```bash
   sudo systemctl stop mysql
   sudo mysqld --wsrep-new-cluster
   ```

2. Verify the cluster started:
   ```bash
   mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size';"
   ```
   You should see `wsrep_cluster_size = 1`.

### Start the Remaining Nodes

1. On the second and third nodes:
   ```bash
   sudo systemctl stop mysql
   sudo systemctl start mysql
   ```

2. Check the cluster size on each node:
   ```bash
   mysql -u root -p -e "SHOW STATUS LIKE 'wsrep_cluster_size';"
   ```
   You should see the cluster size increase with each node (e.g., 2, then 3).

---

## Step 4: Verify Cluster Functionality

1. Check the cluster status:
   ```sql
   SHOW STATUS LIKE 'wsrep%';
   ```

2. Test replication:
   - Create a test database on one node:
     ```sql
     CREATE DATABASE testdb;
     ```
   - Verify it appears on the other nodes:
     ```sql
     SHOW DATABASES;
     ```

---

## Step 5: Optional: Set Up Galera Arbitrator (garbd)

For a two-node cluster, adding a Galera Arbitrator (garbd) prevents split-brain scenarios.

1. Install `galera-arbitrator`:
   ```bash
   sudo apt install galera-arbitrator-4
   ```

2. Configure `garbd`:
   ```bash
   sudo vi /etc/default/garbd
   ```
   Add:
   ```plaintext
   GARBD_OPTS="--address=gcomm://NODE1_IP,NODE2_IP --group=galera_cluster --options='pc.weight=0'"
   ```

3. Start the arbitrator:
   ```bash
   sudo systemctl start garbd
   ```

---

## Step 6: Maintenance Tips

1. Monitor cluster size:
   ```sql
   SHOW STATUS LIKE 'wsrep_cluster_size';
   ```

2. Monitor cluster health:
   ```sql
   SHOW STATUS LIKE 'wsrep_cluster_status';
   ```

3. Regularly back up databases:
   ```bash
   mysqldump -u root -p --all-databases > backup.sql
   ```

---

This completes the setup of a Galera MySQL Cluster. For further customization or troubleshooting, consult the official MariaDB and Galera documentation.

