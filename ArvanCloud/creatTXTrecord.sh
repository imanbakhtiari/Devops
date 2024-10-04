curl -X POST "https://napi.arvancloud.ir/cdn/4.0/domains/{domain}/dns-records" \
-H "Authorization: Apikey <APIKEY>" \
-H "Content-Type: application/json" \
-d '{
  "value": {
    "text": "YOURTXTMESSAGE"
  },
  "type": "txt",
  "name": "nameoftxt",
  "ttl": 120,
  "cloud": false,
  "upstream_https": "default",
  "ip_filter_mode": {
    "count": "single",
    "order": "none",
    "geo_filter": "none"
  }
}'

