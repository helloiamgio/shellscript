#!/bin/ksh

#########################################################################################
#
#
#       This script will kill all the forte running processes
#
#       or, whit the option "-n", it kills also the nodemgr process
#
#
#
#########################################################################################


if [ ! -n "$FORTE_ROOT" ]
then
        echo FORTE_ROOT environment variables not set!  Quitting...
        exit 1
fi

if [[ "$1" != "-n" && "$1" != "" ]]
then
       echo "Usage:\n $0 [-n]"
       exit 1

else


OUT_FILE=listprocess.sh
IAM=`whoami`

# Without the parameter kill all the running processes

        if [ "$1" = "" ]
        then
                ps -fu $IAM|/usr/xpg4/bin/grep -e 'ftexec'|awk '{ i=index($0,"grep");
                        if (i==0)
                                print "kill -9 "$2
                        }' > ${OUT_FILE}

# With the parameter -n kills also the nodemgr process
        else
                ps -fu $IAM|/usr/xpg4/bin/grep -e '/install/bin/nodemgr' -e 'ftexec' |awk '{ i=index($0,"grep");
                        if (i==0)
                                print "kill -9 "$2
                        }' > ${OUT_FILE}
        fi
        chmod +x ${OUT_FILE}

        ${OUT_FILE}

        nproc=`wc ${OUT_FILE}|awk '{print $1}'`

        echo $nproc process killed.
        rm $OUT_FILE
fi
