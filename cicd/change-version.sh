#!/bin/bash

# Define the path to your docker-compose.yml
COMPOSE_FILE="docker-compose.yml"

# Define the name of the service and the image base name
SERVICE_NAME="your_service_name"
IMAGE_BASE_NAME="your_docker_image_name"

# Extract the current version from the docker-compose.yml file
current_version=$(awk -v service="$SERVICE_NAME" -v image_base="$IMAGE_BASE_NAME" '
  $0 ~ service && $0 ~ image_base {
    match($0, /:v[0-9]+/, version);
    if (version[0] != "") {
      gsub("v", "", version[0]);
      print version[0];
    }
  }
' $COMPOSE_FILE)

# Check if a version was found
if [ -z "$current_version" ]; then
  echo "Current version not found in $COMPOSE_FILE"
  exit 1
fi

# Increment the version number
new_version=$((current_version + 1))

# Update the docker-compose.yml file with the new version
sed -i "s/:v$current_version/:v$new_version/g" $COMPOSE_FILE

echo "Updated $COMPOSE_FILE from v$current_version to v$new_version"

