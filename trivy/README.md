```
sudo docker save -o image.tar imagename:tag
```
```
sudo  docker load -i image.tar
```
```
sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/root/ aquasec/trivy:latest --timeout 30m image basa/walletback:v1 > trivy_scan_output.txt
```
