curl -X POST "https://napi.arvancloud.ir/cdn/4.0/domains/<yourdomain>/dns-records" \
-H "Authorization: Apikey <APIKEY>" \
-H "Content-Type: application/json" \
-d '{
  "value": [
    {
      "ip": "1.2.3.4",
      "port": 1,
      "weight": 1000,
      "country": "US"
    }
  ],
  "type": "a",
  "name": "subdomain",
  "ttl": 120,
  "cloud": false,
  "upstream_https": "default",
  "ip_filter_mode": {
    "count": "single",
    "order": "none",
    "geo_filter": "none"
  }
}'

