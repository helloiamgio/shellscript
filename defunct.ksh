#!/bin/bash
defunct(){
    echo "Children:"
    ps -ef | head -n1
    ps -ef | grep defunct
    echo "------------------------------"
    echo "Parents:"
    ppids="$(ps -ef | grep defunct | awk '{ print $3 }')"
    echo "$ppids" | while read ppid; do
        ps -A | grep "$ppid"
    done
}

defunct

# egrep -v '^1$ = Make sure the process is not the init process.
# awk '{print $3}' = Print the parent process.

first_parent_of_first_dead_kid=$(ps -ef | grep [d]efunct | awk '{print $3}' | head -n1 | egrep -v '^1$')
echo "$first_parent_of_first_dead_kid"

# If the first parent of the first dead kid is httpd, then kill it.
if ps -ef | grep $first_parent_of_first_dead_kid | grep httpd
then
    echo "We have a defunct process whose parent process is httpd" | logger -t KILL-DEFUNCT-HTTPD
    echo "killing $first_parent_of_first_dead_kid" | logger -t KILL-DEFUNCT-HTTPD
    kill $first_parent_of_first_dead_kid 2>&1 | logger -t KILL-DEFUNCT-HTTPD
fi