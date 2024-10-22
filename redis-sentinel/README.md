# Redis Sentinel Installation Guide

## Step 1: Install Redis

1. **Update the package repository:**

    ```bash
    sudo apt update
    ```

2. **Install Redis:**

    ```bash
    sudo apt install redis-server
    ```

3. **Verify Redis installation:**

    After installation, Redis will start automatically. You can verify that Redis is running by using:

    ```bash
    sudo systemctl status redis
    ```

---

## Step 2: Configure Redis for Sentinel

1. **Edit the Redis configuration file:**

    ```bash
    sudo nano /etc/redis/redis.conf
    ```

2. **Configure the bind directive:**

    By default, Redis only listens on `localhost`. If you want Redis to be accessible from other machines, you need to bind it to an external IP or use `0.0.0.0` to allow connections from all interfaces. Look for the line:

    ```bash
    bind 127.0.0.1
    ```

    and change it to:

    ```bash
    bind 0.0.0.0
    ```

3. **Enable Redis persistence (optional):**

    Uncomment the `save` directives to enable persistence:

    ```bash
    save 900 1
    save 300 10
    save 60 10000
    ```

4. **Restart Redis:**

    After making changes, restart Redis:

    ```bash
    sudo systemctl restart redis
    ```

---

## Step 3: Configure Redis Sentinel

1. **Create a Redis Sentinel configuration file:**

    Redis Sentinel has its own configuration file. You can copy the default Redis configuration file and modify it for Sentinel:

    ```bash
    sudo cp /etc/redis/redis.conf /etc/redis/sentinel.conf
    ```

2. **Edit the Sentinel configuration file:**

    Open the `sentinel.conf` file:

    ```bash
    sudo nano /etc/redis/sentinel.conf
    ```

3. **Add Sentinel configuration:**

    At the top of the file, add a few essential configurations:

    ```bash
    port 26379
    sentinel monitor mymaster 127.0.0.1 6379 2
    sentinel down-after-milliseconds mymaster 5000
    sentinel parallel-syncs mymaster 1
    sentinel failover-timeout mymaster 60000
    ```

    - `mymaster`: The name of the master Redis instance that Sentinel will monitor.
    - `127.0.0.1`: The IP address of the master Redis instance (you can replace it with the actual IP).
    - `6379`: The Redis port (default).
    - `2`: The number of Sentinel instances that must agree that the master is down.

4. **Start Redis Sentinel:**

    You can start Redis Sentinel using the following command:

    ```bash
    sudo redis-server /etc/redis/sentinel.conf --sentinel
    ```

---

## Step 4: Running Redis Sentinel as a Service

If you want Redis Sentinel to run as a service, follow these steps:

1. **Create a service file for Redis Sentinel:**

    ```bash
    sudo nano /etc/systemd/system/redis-sentinel.service
    ```

2. **Add the following configuration:**

    ```ini
    [Unit]
    Description=Redis Sentinel
    After=network.target

    [Service]
    User=redis
    Group=redis
    ExecStart=/usr/bin/redis-server /etc/redis/sentinel.conf --sentinel
    ExecStop=/usr/bin/redis-cli -p 26379 shutdown
    Restart=always

    [Install]
    WantedBy=multi-user.target
    ```

3. **Enable and start the service:**

    ```bash
    sudo systemctl enable redis-sentinel
    sudo systemctl start redis-sentinel
    ```

4. **Check the status of Redis Sentinel:**

    ```bash
    sudo systemctl status redis-sentinel
    ```

---

## Step 5: Verify Redis Sentinel Setup

Once Redis Sentinel is running, you can use the `redis-cli` to verify its status:

```bash
redis-cli -p 26379
```

