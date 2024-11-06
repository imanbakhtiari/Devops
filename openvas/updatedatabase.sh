#!/bin/bash
sudo docker exec -it <container_name_or_id> /bin/bash -c "\
  greenbone-feed-sync --type GVMD_DATA && \
  greenbone-feed-sync --type SCAP && \
  greenbone-feed-sync --type CERT"

