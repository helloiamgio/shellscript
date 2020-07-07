#!/bin/ksh

apache_vals() {
PROCESSORS=`grep processor /proc/cpuinfo | wc -l`
APACHE_PID=`cat /var/run/httpd/httpd.pid`
PS_OUTPUT=`ps ho pcpu,pmem --ppid ${APACHE_PID} --pid ${APACHE_PID} | sed -e 's/[[:space:]]//' -e 's/[[:space:]]\+/,/g'`
CPU=0
MEMORY=0
for LINE in $PS_OUTPUT
do
        PROCESS_CPU=`echo "${LINE}" | cut -f 1 -d ','`
        PROCESS_MEMORY=`echo "${LINE}" | cut -f 2 -d ','`
        CPU=`echo |awk "{print ${PROCESS_CPU} + ${CPU}}"`
        MEMORY=`echo |awk "{print ${PROCESS_MEMORY} + ${MEMORY}}"`
done

CPU=`echo | awk "{print ${CPU}/${PROCESSORS}}"`
echo "%CPU , %MEM"
echo "${CPU} , ${MEMORY}"
}

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
  COUNT=$(ps aux | grep -c httpd)
}
errMail(){
  echo "MAIL con ALTERT e report spedita.."
  mailx -s "ALERT HTTPD SERVICE_HELP on $HOSTNAME" giorgio.tarozzi@altran.it < $MAILPWD/txtmail
}

rmtext(){
if [ -f $MAILPWD/txtmail ]
then
        rm -f $MAILPWD/txtmail
fi
}

check_page_status() {
TESTHTTP=$(curl -IsS http://servicehelp4.mipl5.vas.omnitel.it/testpage.html | head -1)
TESTSTATUS=$(echo $TESTHTTP |  cut -f2 -d" ")
TESTPAGE=$(curl -sS http://servicehelp4.mipl5.vas.omnitel.it/testpage.html | grep -c PAGE_OK)
TESTFINAL=$(ab -c 2 -n 10 http://servicehelp4.mipl5.vas.omnitel.it/testpage.html | grep -A2 "Complete requests")
TESTOK=$(echo $TESTFINAL | sed 's/ //g' | awk -F'[:]' '{print $2;exit}' | sed 's/Failedrequests//g')
TESTFAIL=$(echo $TESTFINAL | sed 's/ //g' | awk -F'[:]' '{print $3;exit}' | sed 's/Writeerrors//g')
TESTWRITE=$(echo $TESTFINAL | sed 's/ //g' | awk -F'[:]' '{print $4;exit}')
if [ $TESTFAIL -gt 0 ] || [ $TESTSTATUS -ne 200 ] || [ $TESTPAGE -ne 1 ] || [ $COUNT -gt 200 ]
then
	errMail
else 
	echo "HTTPD STATUS = "$TESTSTATUS
	echo "REQUEST STATUS = "$TESTFINAL 
	echo "TOT HTTPD PROC = "$COUNT
	apache_vals
fi	
}

START=$PWD
MAILPWD=/tmp
clear
httpd_proc
check_page_status
echo "HTTPD STATUS : "$TESTSTATUS > $MAILPWD/txtmail
echo ; echo "LIST OF PROCESS : " >> $MAILPWD/txtmail
defunct >> $MAILPWD/txtmail
echo ; echo "REQUEST STATUS : " >> $MAILPWD/txtmail
echo $TESTFINAL >> $MAILPWD/txtmail
rmtext
