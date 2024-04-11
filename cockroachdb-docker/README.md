## cockroachdb installation 

### first of all you need docker
### install dokcer from this link 
[Docker Installation](https://docs.docker.com/engine/install/ubuntu/)
### then pull cockroachdb image 
```bash
sudo docker pull cockroachdb/cockroach:v23.2.3
```
### **then use docker-compose.yml in repository**

###  after that we need to prepare it for production (cockroachdb doesn't have username or password by --insecure and everyone can connect to it)
### so we need certificate for production
### Generating ca
```bash
docker exec -it cocroach0 cockroach cert create-ca --certs-dir=/certs --ca-key=/certs/ca.key
```
### For second node
```bash 
docker exec -it cockroach cockroach cert create-node second --certs-dir=/certs --ca-key=/certs/ca.key
docker exec -it cockroach mv /certs/node.key /certs/second.key
docker exec -it cockroach mv /certs/node.crt /certs/second.crt
```
### For third node
```bash
docker exec -it cockroach cockroach cert create-node third --certs-dir=/certs --ca-key=/certs/ca.key
docker exec -it cockroach mv /certs/node.key /certs/third.key
docker exec -it cockroach mv /certs/node.crt /certs/third.crt
```
### For client
```bash
docker exec -it cockroach cockroach cert create-client client --certs-dir=/certs --ca-key=/certs/ca.key
```
### then use production.yml compose file in repository
