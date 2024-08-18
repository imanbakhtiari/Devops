#!/bin/bash

# Ensure directories exist
mkdir -p /opt/atlassian/jira
mkdir -p /var/atlassian/application-data/jira

# Copy default configuration files if they don't exist
if [ ! -d "/opt/atlassian/jira/bin" ]; then
  cp -r /opt/atlassian/jira-default/* /opt/atlassian/jira/
fi

if [ ! -d "/var/atlassian/application-data/jira/plugins" ]; then
  cp -r /var/atlassian/application-data/jira-default/* /var/atlassian/application-data/jira/
fi

# Start Jira
exec "$@"
