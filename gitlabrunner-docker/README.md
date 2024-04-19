```
version: '2.1'

services:
  gitlab-runner:
    image: gitlab/gitlab-runner:latest
    restart: always
    volumes:
      - ./config:/etc/gitlab-runner
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - RUNNER_NAME=app1
      - CI_SERVER_URL=https://gitlab.domain.com/
      - RUNNER_EXECUTOR=shell
      - DOCKER_TLS_CERTDIR=/certs
      - DOCKER_HOST=unix:///var/run/docker.sock
      - DOCKER_IMAGE=alpine:latest
      - DOCKER_VOLUMES=/cache
      - DOCKER_NETWORK_MODE=host
    network_mode: host
```
