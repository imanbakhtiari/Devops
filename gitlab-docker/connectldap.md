```
gitlab_rails['ldap_enabled'] = true
gitlab_rails['prevent_ldap_sign_in'] = false

###! **remember to close this block with 'EOS' below**
 gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
   main: # 'main' is the GitLab 'provider ID' of this LDAP server
    label: 'YOURCOMPANYNAME'
    host: '10.130.0.40'
    port: 389
    uid: 'sAMAccountName'
    #bind_dn: 'CN=gitlab,OU=DevOps,OU=Staff,OU=Users,OU=EXAMPLE,DC=EXAMPLE,DC=Co'
    bind_dn: 'CN=gitlab,OU=GITLAB,OU=SERVICES,DC=domain,DC=ir'
    password: 'password'
    encryption: 'plain'
    verify_certificates: false
    active_directory: true
    #base: 'OU=DevOps,OU=Staff,OU=Users,OU=EXAMPLE,DC=EXAMPLE,DC=Co'
    #group_base: 'CN=gitlab,OU=DevOps,OU=Staff,OU=Users,OU=EXAMPLE,DC=EXAMPLE,DC=Co'
    #admin_group: 'Domain Admins'
    base: 'OU=basa-users,DC=domain,DC=ir'
    group_base: 'OU=basa-users,DC=domain,DC=ir'
    admin_group: 'Domain Users'
```
