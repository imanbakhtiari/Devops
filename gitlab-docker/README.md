```
version: "2.1"

services:
  gitlab:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    hostname: 'gitlab.domain.com'
    container_name: gitlab-master
    environment:
      GITLAB_OMNIBUS_CONFIG:
        external_url 'https://gitlab.domain.com'
        #        For LetsEncrypt SelfHost Sign
        #        letsencrypt['enable'] = true
        #        letsencrypt['contact_emails'] = ['mail@mail.com']
        gitlab_rails['gitlab_shell_ssh_port'] = 2222
        gitlab_rails['time_zone'] = 'Tehran'
        #nginx['redirect_http_to_https'] = true
        # nginx['ssl_certificate'] = "/opt/gitlab/ssl/gitlab.crt"
        # nginx['ssl_certificate_key'] = "/opt/gitlab/ssl/gitlab.key"
    ports:
      - '80:80'
      - '443:443'
      - '2222:22'
      - '5050:5050'
    volumes:
      - '/srv/gitlab/config:/etc/gitlab'
      - '/srv/gitlab/logs:/var/log/gitlab'
      - '/srv/gitlab/data:/var/opt/gitlab'
        #     - '/srv/gitlab/backups:/var/opt/gitlab/backups'
        #     - '/srv/gitlab/ssl:/var/opt/gitlab/ssl'
```
