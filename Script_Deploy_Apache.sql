#!/bin/sh

#####################apacheInstaller####################################
# by: kani
# Pre-requisites:
# You must download and install in THIS ORDER:
#
# pcre-8.30 (ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre)
# openssl-1.0.1c (http://www.openssl.org)
# apr-1.4.6
# apr-util-1.4.1
# httpd-2.4.2 (apache)
#
# I gathered all the files in:
#     /confman/DIRECTORIES
#
# NOTE: this was done in a Solaris 10 x86-64 bit machine!
#
# HOW TO: execute the script
# chmod u+x apacheInstaller.sh
# source ./apacheInstaller.sh 
# NOTE: source is used for the export of the ENV variables!
#######################################################################

#Set ENV variables
export LDFLAGS=" -L/usr/sfw/lib -R/usr/sfw/lib -L/usr/X/lib -R/usr/X/lib -L/usr/X11/lib -R/usr/X11/lib -L/usr/ccs/lib -R/usr/ccs/lib "
export PATH=/usr/ccs/bin:/usr/sbin:/usr/bin:/usr/sfw/bin:/usr/sfw/sbin:/usr/ccs/bin/amd64:/develop/confman/binutils/bin
export LD_LIBRARY_PATH=/usr/lib:/usr/sfw/lib
export LD_LIBRARY_PATH_64=/usr/lib/64:/usr/sfw/lib/64
#Dont use CC, use GCC! This is VERY important. It wont work otherwise!!
export CC=gcc
export CFLAGS=-"m64 -O3"
export CPP_FLAGS=-"m64 -O3"
alias gcc=/develop/confman/binutils/bin/gcc
alias make=/develop/confman/binutils/bin/make



#also used:
#export LD_LIBRARY_PATH=/usr/lib/64:/usr/sfw/lib/64
#but not sure if this is needed. Maybe LD_LIBRARY_PATH_64 is enough?

#Install PCRE
#The -m64 flag is FUNDAMENTAL!!! Not sure about the others ---> OK
cd /confman/apachesrc/pcre-8.43
./configure --disable-cpp CFLAGS="-g -O3" CC="gcc -m64" --prefix=/confman/pcre8.43
gmake clean
gmake
gmake install

#Install OPENSSL --> OK
cd /confman/apachesrc/openssl-1.0.0s
./config --prefix=/develop/confman/openssl1.0.0 shared solaris64-gcc -m32
gmake clean
gmake
gmake install

#Install ARP --> OK
cd /confman/apachesrc/apr-1.7.0
./configure --prefix=/confman/apr1.7.0 --with-gnu-ld --enable-threads
gmake clean
gmake
gmake install

#Install ARP-UTIL  
cd /confman/apachesrc/apr-util-1.6.1
./configure --prefix=/confman/apr-util.1.6.1  --with-apr=/confman/apr1.7.0 --with-crypto --with-openssl=/usr/local/ssl/lib --enable-threads  --with-nss=/usr/local/ssl/lib
gmake clean
gmake
gmake install

#Install Apache. THE HOT PART!! --enable-pie
cd /confman/apachesrc/httpd-2.4.18
./configure --prefix=/develop/confman/apache2.4.18 --enable-so --enable-module=all --enable-mods-shared=all --enable-proxy --enable-proxy-connect --enable-proxy-ftp --enable-proxy-http --enable-proxy-ajp --enable-proxy-balancer --enable-ssl --with-ssl=/develop/confman/openssl1.0.1 --enable-static-support --enable-static-htpasswd --enable-static-htdigest --enable-static-rotatelogs --enable-static-logresolve --enable-cgi --enable-vhost --enable-imagemap --with-mpm=prefork --with-pcre=/develop/confman/pcre8.43 --with-included-apr 
gmake clean
gmake
gmake install

./configure --prefix=/develop/confman/apache2.4.18 --with-included-apr --enable-so -enable-ssl=shared --with-ssl=/develop/confman/openssl1.0.1 --with-pcre=/develop/confman/pcre8.43


 ./configure --prefix=/develop/confman/apache2.4.18 --with-included-apr --enable-so -enable-ssl=shared --with-ssl=/develop/confman/openssl1.0.1 --with-pcre=/develop/confman/pcre8.43


