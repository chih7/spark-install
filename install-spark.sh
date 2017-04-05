#!/bin/bash

#auto_install spark
#design for ubuntu and debian but only tested in ubuntu server 16.04
#Maintainer: Jiaxin Qi i@chih.me

hadoop_pkgver=2.7
spark_pkgver=2.1.0
mirror=http://mirrors.aliyun.com
depends=(openssh-server openjdk-8-jdk wget)
MASTER_HOST="spark-master"
#fixme while [ $i -lt $N ];do
SLAVE_HOST1="spark-slave1"
SLAVE_HOST2="spark-slave2"
MASTER_IP="192.168.56.101"
SLAVE_IP1="192.168.56.102"
SLAVE_IP2="192.168.56.103"

. ./spark_config/lib.sh

function install_depends(){
	apt-get update
	for i in ${depends[*]}; do
		if ! dpkg -l "$i">/dev/null ; then
	    	apt-get -y install $i
	   	fi
	done	
}

function install_spark(){
    if [ -e spark-${spark_pkgver}-bin-hadoop${hadoop_pkgver}.tgz ];then
        rm spark-${spark_pkgver}-bin-hadoop${hadoop_pkgver}.tgz
	fi
#	while true
#	do
#        wget $(mirror)/apache/hadoop/common/hadoop-${pkgver}/hadoop-${pkgver}.tar.gz
#        wget $(mirror)/apache/hadoop/common/hadoop-${pkgver}/hadoop-${pkgver}.tar.gz.mds
#        md5_1 = `cat hadoop-2.6.0.tar.gz.mds | grep 'MD5'`
#        md5_2 = `md5sum hadoop-${pkgver}.tar.gz | tr "a-z" "A-Z"`
#        if [ $md5_1 == $md5_2 ];then
#            break
#        else
#            echo "checksum not pass"
#        fi
#    done
    wget ${mirror}/apache/spark/spark-2.1.0/spark-${spark_pkgver}-bin-hadoop${hadoop_pkgver}.tgz && \
    tar -xzvf spark-${spark_pkgver}-bin-hadoop${hadoop_pkgver}.tgz && \
    mv spark-${spark_pkgver}-bin-hadoop${hadoop_pkgver} /usr/local/spark
}

function config(){
#ENV
    echo "
# set environment variable
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
"   >> /etc/profile.d/spark.sh
    source /etc/profile.d/spark.sh
    
    echo "$MASTER_IP    $MASTER_HOST" >> /etc/hosts
    echo "$SLAVE_IP1    $SLAVE_HOST1" >> /etc/hosts
    echo "$SLAVE_IP2    $SLAVE_HOST2" >> /etc/hosts
    
    # ssh without key
    ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
    
    cp -r ./spark_config/* /tmp/
    
    mv /tmp/slaves /usr/local/spark/conf
    cp /usr/local/spark/conf/spark-env.sh.template /usr/local/spark/conf/spark-env.sh
    echo "SPARK_MASTER_HOST=spark-master" >> /usr/local/spark/conf/spark-env.sh
    echo "SPARK_LOCAL_IP=spark-xxxx" >> /usr/local/spark/conf/spark-env.sh
}

pre_install
install_depends
install_spark
config

echo "Done! please reboot" 1>&2
