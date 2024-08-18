#!/bin/bash
# java -jar atlassian-agent.jar -d -m [yourEmail] -n BAT -p jira -o http://[yourServerIp] -s [serverId]
#KeyGen usage: java -jar /home/basa/jira-docker/atlassian-agent.jar [-d] [-h] -m
#       <arg> [-n <arg>] -o <arg> -p <arg> -s <arg>
# -d,--datacenter           Data center license[default: false]
# -h,--help                 Print help message
# -m,--mail <arg>           License email
# -n,--name <arg>           License name[default: <license email>]
# -o,--organisation <arg>   License organisation
# -p,--product <arg>        License product, support:
#                           [crowd: Crowd]
#                           [jsm: JIRA Service Management]
#                           [questions: Questions plugin for Confluence]
#                           [crucible: Crucible]
#                           [capture: Capture plugin for JIRA]
#                           [conf: Confluence]
#                           [training: Training plugin for JIRA]
#                           [*: Third party plugin key, looks like:
#                           com.foo.bar]
#                           [bitbucket: Bitbucket]
#                           [tc: Team Calendars plugin for Confluence]
#                           [bamboo: Bamboo]
#                           [fisheye: FishEye]
#                           [portfolio: Portfolio plugin for JIRA]
#                           [jc: JIRA Core]
#                           [jsd: JIRA Service Desk]
#                           [jira: JIRA Software(common jira)]
# -s,--serverid <arg>       License server ID
#
#================================================================================
#
## Crack agent usage: append -javaagent arg to system environment: JAVA_OPTS.
## Example(execute this command or append it to setenv.sh/setenv.bat file):
#
#  export JAVA_OPTS="-javaagent:/home/basa/jira-docker/atlassian-agent.jar ${JAVA_OPTS}"
#
## Then start your confluence/jira server.

## READ THIS PLEASE
## replace your email  info

# jira service management
sudo docker exec -it jira java -jar /opt/atlassian/jira/atlassian-agent.jar -m imanbakhtiyari.it@gmail.com -o domain.tld -s BZRR-4BL3-X6JL-D2CB -p jsm
# jira software
#sudo docker exec -it jira java -jar /opt/atlassian/jira/atlassian-agent.jar -m imanbakhtiyari.it@gmail.com -o domain.tld -s BZRR-4BL3-X6JL-D2CB -p jira
# jira core
#sudo docker exec -it jira java -jar /opt/atlassian/jira/atlassian-agent.jar -m imanbakhtiyari.it@gmail.com -o domain.tld -s BZRR-4BL3-X6JL-D2CB -p jc

