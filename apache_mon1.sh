#!/bin/bash
MY_APACHE_LOG="/var/log/httpd/access_log";
ADMIN_EMAIL="youremail@example.com"
DATESTAMP=`date +"%d-%m-%y"`;
CHECK_LOG=/var/log/httpd/mycheck_log
echo "APACHE LOG STATISTICS FOR " ${DATESTAMP} > ${CHECK_LOG};
FIRST_ENTRY=`head -1 ${MY_APACHE_LOG} | cut -d\" -f1 | cut -d[ -f2 | cut -d] -f1`
echo "FIRST APACHE LOG ENTRY/HIT AT: " $FIRST_ENTRY >> ${CHECK_LOG}
echo " " >> ${CHECK_LOG}
TOTAL_ENTRIES=`cat ${MY_APACHE_LOG} | wc -l`;
echo "TOTAL APACHE LOG ENTRIES SINCE THEN: " $TOTAL_ENTRIES >> ${CHECK_LOG}
echo -n "...10%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 USER AGENTS IN LAST 600.000 HITS: " >> ${CHECK_LOG} ;
tail -600000 ${MY_APACHE_LOG} | cut -d\" -f6 | sort | uniq -i -d -c | sort -rh | head -10 >> ${CHECK_LOG}
echo -n "...20%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 IPs IN LAST 600.000 HITS:" >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} |awk '{print $1}' |sort | uniq -c | sort -rn | head -10 >> ${CHECK_LOG};
echo -n "...30%...";
echo " " >> ${CHECK_LOG}
echo "RESPONSES IN LAST 600.000 HITS: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk '{print $9}' | sort | uniq -c >> ${CHECK_LOG};
echo -n "...30%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 URLs WITH 500 RESPONSE CODE: " >> ${CHECK_LOG};
awk '($9 ~ /500/)' ${MY_APACHE_LOG} | awk '{print $7}' | grep -v xcf | grep -v xce | sort | uniq -c | sort -rn | head -10 >> ${CHECK_LOG};
echo -n "...40%...";
echo " " >> ${CHECK_LOG}
echo "LAST 10 URLs WITH 500 RESPONSE CODE: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk '($9 ~ /500/)' | awk -F\" '{print $1 $2 }' | head -10 >> ${CHECK_LOG};
echo -n "...50%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 URLs WITH 400 (bad request) RESPONSE CODE: " >> ${CHECK_LOG};
awk '($9 ~ /400/)' ${MY_APACHE_LOG} | awk '{print $7}' | grep -v xcf | grep -v xce | sort | uniq -c | sort -rn | head -10 >> ${CHECK_LOG};
echo -n "...55%...";
echo " " >> ${CHECK_LOG}
echo "LAST 10 URLs WITH 400 (bad request) RESPONSE CODE: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk '($9 ~ /400/)' | awk -F\" '{print $1 $2 }' | head -10 >> ${CHECK_LOG};
echo -n "...60%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 URLs WITH 401 (unauthorized) RESPONSE CODE: " >> ${CHECK_LOG};
awk '($9 ~ /401/)' ${MY_APACHE_LOG} | awk '{print $7}' | grep -v xcf | grep -v xce | sort | uniq -c | sort -rn | head -10 >> ${CHECK_LOG};
echo -n "...65%...";
echo " " >> ${CHECK_LOG}
echo "LAST 10 URLs WITH 401 (unauthorized) RESPONSE CODE: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk '($9 ~ /401/)' | awk -F\" '{print $1 $2 }' | head -10 >> ${CHECK_LOG};
echo -n "...70%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 URLs WITH 403 (forbidden) RESPONSE CODE: " >> ${CHECK_LOG};
awk '($9 ~ /403/)' ${MY_APACHE_LOG} | awk '{print $7}' | grep -v xcf | grep -v xce | sort | uniq -c | sort -rn | head -10 >> ${CHECK_LOG};
echo -n "...75%...";
echo " " >> ${CHECK_LOG}
echo "LAST 10 URLs WITH 403 (forbidden) RESPONSE CODE: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk '($9 ~ /403/)' | awk -F\" '{print $1 $2 }' | head -10 >> ${CHECK_LOG};
echo -n "...80%...";
echo " " >> ${CHECK_LOG}
echo "LAST 10 URLs WITH 404 (not found) RESPONSE CODE: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk '($9 ~ /404/)' | awk -F\" '{print $1 $2 }' | head -10 >> ${CHECK_LOG};
echo -n "...90%...";
echo " " >> ${CHECK_LOG}
echo "TOP-10 POPULAR URLs IN LAST 600.000 HITS: " >> ${CHECK_LOG};
tail -600000 ${MY_APACHE_LOG} | awk -F\" '{print $2}' | sort | uniq -c | sort -rn | head -10 >> ${CHECK_LOG};
echo -n "...100%...";
echo " " >> ${CHECK_LOG}
echo "...Ready!...";
echo " Sending email to webmaster";
### mail -s "${MYFQDN}: Apache Logs Report for ${DATESTAMP}" "${ADMIN_EMAIL}" < ${CHECK_LOG}
more ${CHECK_LOG};