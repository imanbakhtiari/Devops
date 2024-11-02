echo '#!/bin/bash
duration=$( { time sleep 5; } 2>&1 | grep real | awk '"'"'{print $2}'"'"' )
cat <<EOF | curl --data-binary @- http://localhost:9091/metrics/job/example_job
# TYPE job_duration_seconds gauge
job_duration_seconds ${duration}
EOF' > push_metrics.sh
chmod +x push_metrics.sh

