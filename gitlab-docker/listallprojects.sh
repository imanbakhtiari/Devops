curl --header "PRIVATE-TOKEN: your_old_gitlab_token" "https://gitlab.xaas.ir/api/v4/projects?per_page=100" | jq -r '.[].path_with_namespace'

