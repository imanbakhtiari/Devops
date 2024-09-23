ps -eo size,pid,user,command --sort -size | \
    awk '{ hr=$1/1024 ; printf("%13.2f Mb ",hr) } { for ( x=4 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |\
    cut -d "" -f2 | cut -d "-" -f1

## also for cpua nd aram both
ps -eo size,%cpu,pid,user,command --sort -size | \
awk '{ mem=$1/1024 ; cpu=$2 ; printf("%13.2f Mb %6.2f%% CPU ", mem, cpu) } { for ( x=5 ; x<=NF ; x++ ) { printf("%s ",$x) } print "" }' |\
cut -d "" -f2 | cut -d "-" -f1

