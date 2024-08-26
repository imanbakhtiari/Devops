##
##/usr/share/elasticsearch/bin$ ls
##elasticsearch           elasticsearch-create-enrollment-token  elasticsearch-geoip     elasticsearch-reconfigure-node  elasticsearch-setup-passwords     elasticsearch-syskeygen
##elasticsearch-certgen   elasticsearch-croneval                 elasticsearch-keystore  elasticsearch-reset-password    elasticsearch-shard               elasticsearch-users
##elasticsearch-certutil  elasticsearch-env                      elasticsearch-node      elasticsearch-saml-metadata     elasticsearch-sql-cli             systemd-entrypoint
##elasticsearch-cli       elasticsearch-env-from-file            elasticsearch-plugin    elasticsearch-service-tokens    elasticsearch-sql-cli-8.14.3.jar

bin\elasticsearch-create-enrollment-token -s node



## on other node

bin\elasticsearch --enrollment-token <enrollment-token>

## edit elasticsearch.yml
## node.attr.data_role: hot
## node.attr.data_role: warm
## node.attr.data_role: cold
## sudo systemctl restart elasticsearch





## how to put data to warm or cold
## PUT _index_template/hot-template
#{
#  "index_patterns": ["hot-*"],
#  "settings": {
#    "index.routing.allocation.require.data_role": "hot"
#  }
#}

