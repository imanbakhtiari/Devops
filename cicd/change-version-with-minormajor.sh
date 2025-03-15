#!/bin/bash

# Define the path to your docker-compose.yml
COMPOSE_FILE="./docker-compose.yml"

# Define the image base name
IMAGE_BASE_NAME="IMAGENAME"

# Extract the current version from docker-compose.yml
current_version=$(grep -Eo "${IMAGE_BASE_NAME}:v[0-9]+\.[0-9]+" "$COMPOSE_FILE" | head -n 1 | sed -E "s|${IMAGE_BASE_NAME}:v||")

# Debugging: Print extracted version
echo "Extracted version: $current_version"

# Check if a version was found
if [ -z "$current_version" ]; then
  echo "Error: Current version not found in $COMPOSE_FILE"
  exit 1
fi

# Extract major and minor versions, ensuring correct format
major_version=$(echo "$current_version" | cut -d. -f1)
minor_version=$(echo "$current_version" | cut -d. -f2)

# Ensure both parts are valid numbers
if ! [[ "$major_version" =~ ^[0-9]+$ ]] || ! [[ "$minor_version" =~ ^[0-9]+$ ]]; then
  echo "Error: Invalid version format in $COMPOSE_FILE"
  exit 1
fi

# Convert minor_version to decimal (remove leading zeros)
minor_version=$((10#$minor_version))

# Increment the minor version properly
if [ "$minor_version" -lt 99 ]; then
  new_minor_version=$(printf "%02d" $((minor_version + 1)))  # Keep two-digit format
  new_major_version=$major_version
elif [ "$minor_version" -eq 99 ]; then
  new_minor_version="00"  # Reset minor to 00 (not 01)
  new_major_version=$((major_version + 1))  # Increment major
else
  echo "Error: Unexpected version format"
  exit 1
fi

# Construct new version
new_version="${new_major_version}.${new_minor_version}"

# Debugging: Print new version
echo "Updating version: $current_version → $new_version"

# Update the docker-compose.yml file with the new version
sed -i "s|${IMAGE_BASE_NAME}:v${current_version}|${IMAGE_BASE_NAME}:v${new_version}|g" "$COMPOSE_FILE"

echo "Updated $COMPOSE_FILE from v$current_version to v$new_version"

