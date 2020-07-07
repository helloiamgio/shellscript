#!/bin/ksh

#
#  This script startup FORTE_APP
#

if [ ! -n "$1" ]
then
        echo usage: startup.sh APPLICATION_CLX
        exit 1
fi

if [ ! -n "$FORTE_ROOT" ]
then
        echo FORTE_ROOT environment variables not set!  Quitting...
        exit 1
fi

APPLICATION_NAME=$1

# running e-script

echo  "--- Starting $APPLICATION_NAME, please wait ..."

escript -fm "(x:80000)" <<EOF> ${FORTE_ROOT}/log/startup_$APPLICATION_NAME.log

FindSubAgent ${APPLICATION_NAME}
startup
quit
EOF
echo  "--- See $FORTE_ROOT/log/startup_$APPLICATION_NAME.log"
