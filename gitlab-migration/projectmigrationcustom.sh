#!/bin/bash

# Configuration
OLD_GITLAB_URL="gitlab.xaas.ir"
NEW_GITLAB_URL="gitlab2.xaas.ir"
OLD_GITLAB_TOKEN="your_old_gitlab_token"
NEW_GITLAB_TOKEN="your_new_gitlab_token"
EXPORT_DIR="./gitlab_exports"
IMPORT_DIR="./gitlab_imports"

# List of specific project names (path_with_namespace) to export and import
PROJECTS=("i.bakhtiari/project-components" "devops/crm" "devops/xaas-mail")

# Create directories for exports and imports
mkdir -p "$EXPORT_DIR"
mkdir -p "$IMPORT_DIR"

# Function to export specific projects from the old GitLab
export_projects() {
    echo "Exporting specific projects from $OLD_GITLAB_URL..."
    for project_name in "${PROJECTS[@]}"; do
        project_id=$(curl -s --header "PRIVATE-TOKEN: $OLD_GITLAB_TOKEN" "https://$OLD_GITLAB_URL/api/v4/projects?search=$project_name" | jq -r '.[0].id')
        if [ -z "$project_id" ]; then
            echo "Project not found: $project_name"
            continue
        fi
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
}

# Function to import specific projects into the new GitLab
import_projects() {
    echo "Importing specific projects into $NEW_GITLAB_URL..."
    for project_name in "${PROJECTS[@]}"; do
        export_file="$EXPORT_DIR/$project_name.tar.gz"
        if [ ! -f "$export_file" ]; then
            echo "Export file not found for project: $project_name"
            continue
        fi
        namespace=$(dirname "$project_name")
        project=$(basename "$project_name")
        echo "Creating namespace: $namespace..."
        curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" -X POST "https://$NEW_GITLAB_URL/api/v4/groups" --data "name=$namespace&path=$namespace"
        echo "Creating project: $project in namespace: $namespace..."
        group_id=$(curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" "https://$NEW_GITLAB_URL/api/v4/groups?search=$namespace" | jq -r '.[0].id')
        curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" -X POST "https://$NEW_GITLAB_URL/api/v4/projects" --data "name=$project" --data "namespace_id=$group_id"
        echo "Uploading and importing project: $project..."
        curl -s --header "PRIVATE-TOKEN: $NEW_GITLAB_TOKEN" -X POST "https://$NEW_GITLAB_URL/api/v4/projects/import" --form "path=$project" --form "namespace=$namespace" --form "file=@$export_file"
    done
}

# Main execution
export_projects
import_projects

echo "Migration completed."

