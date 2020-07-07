#!/bin/bash
SUBJECT="RESTART APACHE HTTPD"
EMAIL="youremailaddress@gmail.com"
MESSAGE="/path/to/message.txt"
IP=$(hostname -I)
response=$(curl --write-out %{http_code} --connect-timeout 5  --silent --output /dev/null http://$IP:443/server-status)
if [ $response -eq 200 ]
then
	echo "All Working well";
else
	echo "Launching"
	kill $(ps aux | grep '[h]ttpd' | awk '{print $2}')
	/etc/init.d/httpd graceful
/bin/mail -s "$SUBJECT" "$EMAIL" < $MESSAGE
fi