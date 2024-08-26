## get the token
```
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```

##
```
sudo /usr/share/kibana/bin/kibana-setup --enrollment-token eyJ2ZXIiOiI4LjE0LjAiLmamadZHIiOlsiMTAuMTMwLjUuMjAwOjkybiiiiaaaMDAiXSwiZmdyIjoiZjM4YzU0NmY0YWIxYWNkNjZkMWI4Y2UxNWJjYjU5YjUxMTZjMWU2MjM4ZThjZjE1NWRlZDZiYWY4MzM4YjJiMyIsImtleSI6IkRFazZDSkVCTHZQWjFXQXFyWDZBOkdfUXUyWXAxU3Npb1BSQmxUS2NPNVEifQ==
```

## in kibana.yml >>>

```
# The URL of the Elasticsearch cluster
elasticsearch.hosts: ["http://localhost:9200"]

# Optional: The server host Kibana is bound to
server.host: "0.0.0.0"

# Optional: The port Kibana is listening on
server.port: 5601

# Optional: Basic authentication (if enabled on Elasticsearch)
elasticsearch.username: "elastic"
elasticsearch.password: "your_password"
```
