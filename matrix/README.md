```
sudo docker compose up -d
```

## and then

```
docker run -it --rm \
  -v $(pwd)/data/synapse:/data \
  -e SYNAPSE_SERVER_NAME=your_domain.com \
  -e SYNAPSE_REPORT_STATS=yes \
  matrixdotorg/synapse:latest generate
````

```
sudo vi ./data/synapse/homeserver.yaml
```

### Review and adjust settings as needed. Pay particular attention to:
##### server_name: Should be set to your domain.
##### report_stats: Set to true or false depending on whether you want to report anonymous usage statistics.

```
docker-compose up -d synapse
```


