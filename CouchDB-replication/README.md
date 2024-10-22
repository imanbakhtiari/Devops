# CouchDB Replication Setup on Three Nodes

## Step 1: Install CouchDB on All Nodes

1. **Update the package repository:**

    ```bash
    sudo apt update
    ```

2. **Install CouchDB:**

    ```bash
    sudo apt install -y couchdb
    ```

3. **Verify CouchDB installation:**

    After installation, CouchDB will start automatically. You can verify that CouchDB is running by using:

    ```bash
    sudo systemctl status couchdb
    ```

---

## Step 2: Configure CouchDB for Cluster Setup

1. **Edit the CouchDB configuration file** on each node:

    ```bash
    sudo nano /opt/couchdb/etc/local.ini
    ```

2. **Bind CouchDB to all interfaces:**

    Change the bind address to allow CouchDB to be accessed over the network. Look for the `[httpd]` section and update the bind address:

    ```ini
    [httpd]
    bind_address = 0.0.0.0
    ```

3. **Enable clustering** by adding the following to the `[cluster]` section:

    ```ini
    [cluster]
    q = 1
    n = 3
    ```

    - `q`: The number of shards per database.
    - `n`: The number of replicas.

4. **Configure the CouchDB admin credentials** in the `[admins]` section (optional but recommended):

    ```ini
    [admins]
    admin = yourpassword
    ```

5. **Restart CouchDB:**

    After making these changes, restart CouchDB:

    ```bash
    sudo systemctl restart couchdb
    ```

---

## Step 3: Setup CouchDB Cluster

1. **Open CouchDB web interface** on one of the nodes:

    Visit the CouchDB web interface at `http://<node-ip>:5984/_utils`.

2. **Join the nodes in the cluster:**

    - In the first node’s web interface, go to the **Cluster** section.
    - Add the IP addresses of the other two nodes using their admin credentials.

    For example, if your nodes are `192.168.1.11`, `192.168.1.12`, and `192.168.1.13`, you will add each node one by one.

3. **Run the following curl command** from one node to add each node to the cluster:

    ```bash
    curl -X POST -H "Content-Type: application/json" http://admin:password@<node1-ip>:5984/_cluster_setup -d '{"action": "add_node", "host": "<node2-ip>", "port": 5984, "username": "admin", "password": "password"}'
    ```

    Run this command from each node to add the other nodes to the cluster.

4. **Finish cluster setup:**

    On one node, finish the cluster setup:

    ```bash
    curl -X POST -H "Content-Type: application/json" http://admin:password@<node1-ip>:5984/_cluster_setup -d '{"action": "finish_cluster"}'
    ```

---

## Step 4: Verify CouchDB Cluster Setup

1. **Check the cluster status:**

    You can verify the cluster setup by running:

    ```bash
    curl http://admin:password@<node1-ip>:5984/_membership
    ```

    This will show the membership details of your CouchDB cluster.

2. **Create a test database** on the cluster:

    You can create a new database from the web interface or by using the following curl command:

    ```bash
    curl -X PUT http://admin:password@<node1-ip>:5984/testdb
    ```

3. **Verify replication:**

    Insert a document into the database and verify that it is replicated across the nodes:

    ```bash
    curl -X POST http://admin:password@<node1-ip>:5984/testdb -d '{"name": "replication test"}' -H "Content-Type: application/json"
    ```

    You can then check the other nodes to ensure the document exists on all of them:

    ```bash
    curl http://admin:password@<node2-ip>:5984/testdb/_all_docs
    ```

---

## Step 5: Enable CouchDB as a Service (Optional)

1. **Ensure CouchDB is enabled to start on boot:**

    On each node, enable CouchDB to start automatically on system boot:

    ```bash
    sudo systemctl enable couchdb
    ```

2. **Check the service status on each node:**

    Make sure CouchDB is running on all nodes:

    ```bash
    sudo systemctl status couchdb
    ```

---

## Step 6: Replication in Action

1. **Test replication** by creating databases and documents on one node and checking that the data replicates across all nodes.

    CouchDB will automatically handle replication as part of its clustered architecture.

