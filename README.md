# Install Spark Cluster with shell script

Spark install script for debian and Ubuntu. but only tested in Ubuntu Server 16.04.

The script will let you setup a 3 node Spark cluster in no more than 10 minutes.

## Installation in a node


```sh
sudo -s
```

```sh
su -
```

```sh
git clone https://github.com/chih7/spark_install.git
```

```sh
cd ./spark_install
```

```sh
./install-spark.sh
```

```
reboot
```

Done

## Run as a cluster

clone the machine or install spark in other machine with the script.

note the ip address must same with the script.

in spark master machine

```sh
sudo -s
```

```sh
su -
```

```sh
./start-spark.sh
```

Done
