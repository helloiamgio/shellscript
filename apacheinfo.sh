#!/bin/sh
PROCESSORS=`grep processor /proc/cpuinfo | wc -l`
APACHE_PID=`cat /var/run/apache2.pid`
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
echo "${CPU},${MEMORY}"