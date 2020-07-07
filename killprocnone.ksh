#!/bin/ksh

# Questo script fa il kill di tutti gli ftexec
# rimasti appesi dopo lo stop di una applicazione

cd
. .profile

>listftexec.out


if [ ! -n "$FORTE_ROOT" ]
then
        echo FORTE_ROOT environment variables not set!  Quitting...
        exit 1
fi

if [ ! -n "$SERVER_NAME" ]
then
        echo SERVER_NAME environment variables not set!  Quitting...
        exit 1
fi


# running e-script

escript -fm "(x:80000)" <<EOF>$FORTE_ROOT/log/listftexec.log
findactenv
findsubagent ${SERVER_NAME}
findsubagent Forte_Executor_${SERVER_NAME}
setoutfile listftexec.out
showagent
setoutfile
showagent
quit
EOF


# Kill degli ftexec rimasti appesi

echo "--- Shutting down ftexec..."

nawk -v V1=$SERVER_NAME '
BEGIN {print "escript -fm \"(x:80000)\" <<EOF>$FORTE_ROOT/log/killftexec_none.log";
print "findactenv";
printf "findsubagent %s\n",V1;
printf "findsubagent Forte_Executor_%s\n",V1;
}
($1 == "Active" && $2 == "Partition" && $3 == "Agent" && $6 == "(ONLINE)"){

executor=$5;

printf "shutdownsubagent %s\n",executor;
}
END {print "findactenv"
print "EOF"}
' listftexec.out>dump.lst

chmod 744 dump.lst
dump.lst

echo "--- Ftexec successfully killed ..."
echo "--- See log file $FORTE_ROOT/log/killftexec_none.log"

rm listftexec.out
rm dump.lst
