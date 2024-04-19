```
version: '3'

services:
  postgres-exporter:
    image: quay.io/prometheuscommunity/postgres-exporter
    environment:
      DATA_SOURCE_NAME: "postgresql://username:password@hostip:port/postgres?sslmode=disable"
    network_mode: host
    restart: always
```
