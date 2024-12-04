import re

log_line = '86.65.155.14 - - [04/Dec/2024:10:40:21 +0000] "POST /MYAPP/index.php HTTP/2.0" 200 131088 "-" "okhttp/3.11.13"'
pattern = r'^(\S+) - - \[(.*?)\] "(.*?)" (\d{3}) (\d+) "-" "(.*?)"$'

match = re.match(pattern, log_line)
if match:
    print("Match successful!")
    print("Groups:", match.groups())
else:
    print("No match.")

