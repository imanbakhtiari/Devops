FROM ubuntu:22.04

# Set environment variables
ENV JIRA_HOME /var/atlassian/application-data/jira
ENV JIRA_INSTALL /opt/atlassian/jira
ENV JIRA_VERSION 9.10.0

# Install dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    openjdk-19-jdk \
    wget \
    curl \
    procps && \
    apt-get clean

# Create jira user and group
RUN groupadd -g 1001 jira && \
    useradd -u 1001 -g jira -m -d ${JIRA_HOME} -s /bin/bash jira

# Create directories
RUN mkdir -p ${JIRA_HOME} ${JIRA_INSTALL} && \
    chmod -R 766 ${JIRA_HOME} ${JIRA_INSTALL} && \
    chown -R jira:jira ${JIRA_HOME} ${JIRA_INSTALL}

COPY response.varfile /tmp/response.varfile
COPY atlassian-jira-software-9.10.0-x64.bin /tmp/jira-installer.bin

# Download and install Jira
RUN chmod +x /tmp/jira-installer.bin
USER jira
RUN /tmp/jira-installer.bin -q -varfile /tmp/response.varfile

# Copy atlassian-agent.jar for licensing
COPY atlassian-agent.jar /opt/atlassian/jira/atlassian-agent.jar
RUN echo 'export JAVA_OPTS="-javaagent:/opt/atlassian/jira/atlassian-agent.jar ${JAVA_OPTS}"' >> /opt/atlassian/jira/bin/setenv.sh

# Create default directories to copy from
USER root
RUN cp -r /opt/atlassian/jira /opt/atlassian/jira-default
RUN cp -r /var/atlassian/application-data/jira /var/atlassian/application-data/jira-default

# Expose the default HTTP and control ports
EXPOSE 8080 8005

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/opt/atlassian/jira/bin/start-jira.sh", "-fg"]

