wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz
tar xzvf Python-2.7.10.tgz
cd Python-2.7.10
yum install gcc
yum install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
./configure --prefix=/usr/local LDFLAGS="-Wl,-rpath /usr/local/lib" && make && make altinstall
ln -s /usr/local/bin/python2.7 /usr/bin/python27
