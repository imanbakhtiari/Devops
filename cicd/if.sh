before_script:
  - if [ "$CI_COMMIT_REF_NAME" == "develop" ]; then
           stage_var="dev";
           ssh_private_key=${ssh_private_key_dev};
           server_ip=${server_ip_dev};
           server_user=${server_user_dev};
    elif [ "$CI_COMMIT_REF_NAME" == "master" ]; then
           stage_var="prod";
           ssh_private_key=${ssh_private_key_prod};
           server_ip=${server_ip_prod};
           server_user=${server_user_prod};
    fi

