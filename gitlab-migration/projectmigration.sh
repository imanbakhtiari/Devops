#!/bin/bash

# Configuration
OLD_GITLAB_URL="gitlab.xaas.ir"
NEW_GITLAB_URL="gitlab2.xaas.ir"
OLD_GITLAB_TOKEN="token"
NEW_GITLAB_TOKEN="token"

EXPORT_DIR="./gitlab_exports"
IMPORT_DIR="./gitlab_imports"

# Create directories for exports and imports
mkdir -p "$EXPORT_DIR"
mkdir -p "$IMPORT_DIR"

# Function to export all projects from the old GitLab
export_projects() {
    echo "Fetching project list from $OLD_GITLAB_URL..."
    page=1
    while :; do
        projects=$(curl -s --header "PRIVATE-TOKEN: $OLD_GITLAB_TOKEN" "https://$OLD_GITLAB_URL/api/v4/projects?per_page=100&page=$page")
        project_count=$(echo "$projects" | jq '. | length')
        if [ "$project_count" -eq 0 ]; then
            break
        fi
        echo "$projects" | jq -r '.[] | .id' | while read -r project_id; do
            project_name=$(curl -s --header "PRIVATE-TOKEN: $OLD_GITLAB_TOKEN" "https://$OLD_GITLAB_URL/api/v4/projects/$project_id" | jq -r '.path_with_namespace')
            echo "Exporting project: $project_name (ID: $project_id)..."
            curl -s --header "PRIVATE-TOKEN: $OLD_GITLAB_TOKEN" -X POST "https://$OLD_GITLAB_URL/api/v4/projects/$project_id/export"
            echo "Waiting for export to be ready..."
            while :; do
                export_status=$(curl -s --header "PRIVATE-TOKEN: $OLD_GITLAB_TOKEN" "https://$OLD_GITLAB_URL/api/v4/projects/$project_id/export" | jq -r '.export_status')
                if [ "$export_status" == "finished" ]; then
                    break
                fi
                sleep 5
            done
            echo "Downloading export for project: $project_name..."
            curl -s --header "PRIVATE-TOKEN: $OLD_GITLAB_TOKEN" "https://$OLD_GITLAB_URL/api/v4/projects/$project_id/export/download" -o "$EXPORT_DIR/$project_name.tar.gz"
        done
        page=$((page + 1))
    done
}

# Function to import all projects into the new GitLab
import_projects() {
    echo "Importing projects into $NEW_GITLAB_URL..."
    find "$EXPORT_DIR" -name "*.tar.gz" | while read -r export_file; do
        project_name=$(basename "$export_file" .tar.gz)
        namespace=$(dirname "$project_name")
        project=$(basename "$project_name")
        echo "Creating namespace: $namespace..."
        curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" -X POST "https://$NEW_GITLAB_URL/api/v4/groups" --data "name=$namespace&path=$namespace"
        echo "Creating project: $project in namespace: $namespace..."
        curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" -X POST "https://$NEW_GITLAB_URL/api/v4/projects" --data "name=$project&namespace_id=$(curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" "https://$NEW_GITLAB_URL/api/v4/groups/$namespace" | jq -r '.id')"
        echo "Uploading and importing project: $project..."
        curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" -X POST "https://$NEW_GITLAB_URL/api/v4/projects/import" --form "path=$project" --form "namespace=$namespace" --form "file=@$export_file"
    done
}

# Main execution
export_projects
import_projects

echo "Migration completed."

