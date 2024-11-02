Check Script Success Rate: To check whether the script succeeded or failed, you could use the following PromQL query:
```
script_success{job="example_job"}
```
This will return 1 if the last execution of the script was successful and 0 if it failed.

Check Script Execution Duration: If you want to see how long the script ran, you can query the duration metric:
```
script_duration_seconds{job="example_job"}
```
This will return the last recorded execution time of your script in seconds.

Average Duration Over Time: To monitor the average duration of your script over a specified time window (e.g., the last 5 minutes), you can use:
```
avg_over_time(script_duration_seconds{job="example_job"}[5m])
```
This will give you the average duration of your script executions in the last 5 minutes.

Count of Success vs. Failures: If you have a script_success gauge and you want to count how many times your script succeeded and failed, you can use:
```
sum(script_success{job="example_job"})
```
This will give you the total number of successful runs. To count failures, you could subtract the success count from the total runs if you have a total run counter.

Create Alerts Based on Script Status: If you want to create an alert if the script fails, you might use:
```
increase(script_success{job="example_job"}[1m]) == 0
```
