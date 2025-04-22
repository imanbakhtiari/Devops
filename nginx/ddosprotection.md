# /etc/nginx/sites-available/yourdomain.conf
```configuration
limit_req_zone $binary_remote_addr zone=perip:10m rate=5r/s;

server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    access_log /var/log/nginx/yourdomain.access.log;
    error_log  /var/log/nginx/yourdomain.error.log warn;

    root /var/www/yourdomain;
    index index.html index.htm;

    # Rate limit suspicious paths
    location ~ ^/(login|api|auth|register|search) {
        limit_req zone=perip burst=10 nodelay;
        limit_req_status 403;

        proxy_pass http://127.0.0.1:8080;  # Or your app/backend
    }

    # No rate limit for everything else
    location / {
        try_files $uri $uri/ =404;
    }
}
```
