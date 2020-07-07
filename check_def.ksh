#!/bin/bash
START=$PWD
clear
defunct(){
   echo "Children:"
   ps -ef | head -n1
   ps -ef | grep defunct | grep -v grep
   echo "------------------------------"
   echo "Parents:"
   ppids="$(ps -ef | grep [d]efunct | awk '{print $3}' | head -n1 | egrep -v '^1$')"
   echo "$ppids" | while read ppid; do
       ps -A | grep "$ppid"
   done
   echo "#######################"
   echo "Apache Parent Process :"
   echo "#######################"
   pstree -p | grep httpd | head -1
}

httpd_proc(){
  echo "Process httpd :"
  COUNT=$(ps aux | grep -c httpd)
  echo "Number : $COUNT"
  if [ $COUNT -gt 100 ]
  then
    errMail
  else
    echo "Number of process is under maximum quota" ; sleep 10
    pstree -p | grep httpd | less
  fi
}
errMail(){
  echo "MAIL con ALTERT e report spedita.."
  mailx -s "Report httpd $HOSTNAME" giorgio.tarozzi@altran.it < $START/txtmail
}

rmtext(){
if [ -f $START/txtmail ]
then
        rm -f $START/txtmail
fi
}

defunct > $START/txtmail
httpd_proc
rmtext
	
