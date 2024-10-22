# MongoDB Replica Set Installation Guide

## Step 1: Install MongoDB

1. **Update the package repository:**

    ```bash
    sudo apt update
    ```

2. **Install MongoDB:**

    ```bash
    sudo apt install -y mongodb
    ```

3. **Verify MongoDB installation:**

    After installation, MongoDB will start automatically. You can verify that MongoDB is running by using:

    ```bash
    sudo systemctl status mongod
    ```

---

## Step 2: Configure MongoDB for Replica Set

1. **Edit the MongoDB configuration file:**

    ```bash
    sudo nano /etc/mongod.conf
    ```

2. **Enable replication:**

    Add or modify the following lines in the configuration file to enable replication and set the replica set name:

    ```yaml
    replication:
       replSetName: "rs0"
    ```

3. **Restart MongoDB:**

    After making changes, restart MongoDB:

    ```bash
    sudo systemctl restart mongod
    ```

---

## Step 3: Initiate the Replica Set

1. **Connect to the MongoDB shell on the primary node:**

    On one of the servers (the one you want to be the initial primary node), open the MongoDB shell:

    ```bash
    mongo
    ```

2. **Initiate the replica set:**

    Use the following command to initiate the replica set:

    ```javascript
    rs.initiate()
    ```

3. **Check the replica set status:**

    After initiation, you can check the replica set status by running:

    ```javascript
    rs.status()
    ```

---

## Step 4: Add Secondary Nodes to the Replica Set

1. **Add the first secondary node:**

    Still in the MongoDB shell on the primary node, run the following command to add the first secondary node (replace with the actual hostname or IP):

    ```javascript
    rs.add("secondary1_hostname:27017")
    ```

2. **Add the second secondary node:**

    Run the following command to add the second secondary node:

    ```javascript
    rs.add("secondary2_hostname:27017")
    ```

    For example, if your MongoDB instances are running on `192.168.1.10`, `192.168.1.11`, and `192.168.1.12`, you would use:

    ```javascript
    rs.add("192.168.1.11:27017")
    rs.add("192.168.1.12:27017")
    ```

---

## Step 5: Verify Replica Set Configuration

1. **Check the status of the replica set:**

    You can check the status of the replica set using:

    ```javascript
    rs.status()
    ```

2. **Test data replication:**

    To ensure that replication is working correctly, insert data into the primary node:

    ```bash
    use mydatabase
    db.mycollection.insert({ name: "replication test" })
    ```

3. **Check the secondary node:**

    Connect to one of the secondary nodes and run the following commands to verify that the data has been replicated:

    ```bash
    rs.slaveOk()  # Allows reading from a secondary node
    db.mycollection.find()
    ```

---

## Step 6: Running MongoDB Replica Set as a Service

1. **Ensure MongoDB is enabled to start on boot:**

    On each node, enable MongoDB to start automatically on system boot:

    ```bash
    sudo systemctl enable mongod
    ```

2. **Start MongoDB service on each node:**

    Make sure MongoDB is running on all nodes:

    ```bash
    sudo systemctl start mongod
    ```

3. **Check MongoDB service status:**

    You can check the status of MongoDB on each node using:

    ```bash
    sudo systemctl status mongod
    ```

