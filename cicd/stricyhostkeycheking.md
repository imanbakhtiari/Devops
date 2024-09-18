### sudo vi ~/.ssh/config

```
Host git.test.ir
  Port 2222
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
```

```
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 git@git.test.ir
```

## in CICD
```
before_script:
  # Add GitLab server's SSH key to known hosts, automatically accepting it
  - mkdir -p ~/.ssh
  - ssh-keyscan -p 2222 git.test.ir >> ~/.ssh/known_hosts
  - chmod 600 ~/.ssh/known_hosts
  - echo -e "Host git.test.ir\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null\n" >> ~/.ssh/config
```
