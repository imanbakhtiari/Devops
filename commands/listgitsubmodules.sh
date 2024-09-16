#!/bin/bash

git config --file .gitmodules --name-only --get-regexp path | while read path_key; do
    url_key=$(echo $path_key | sed 's/\.path/.url/')
    path=$(git config --file .gitmodules --get $path_key)
    url=$(git config --file .gitmodules --get $url_key)
    echo "Submodule: $path"
    echo "URL: $url"
    echo ""
done



############# or

git config --file .gitmodules --get-regexp url

