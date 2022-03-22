#!/bin/bash

#	Script for install Softether
#	Works with Ubuntu 18.04 and higher

NET_FORWARD="net.ipv4.ip_forward=1"
sysctl -w  ${NET_FORWARD}
sed -i "s:#${NET_FORWARD}:${NET_FORWARD}:" /etc/sysctl.conf

sudo apt -y install cmake gcc g++ make libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev git
wget softether-src.tar.gz https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-src-v4.38-9760-rtm.tar.gz
tar -xvf softether-src-v4.38-9760-rtm.tar.gz
rm softether-src-v4.38-9760-rtm.tar.gz
cd v4.38-9760
./configure
make

cp -p Makefile Makefile_bak
cat Makefile_bak \
	| sed 's,/usr/bin/,/usr/local/bin/,' \
	| sed 's,/usr/vpnserver/,/usr/local/softether/vpnserver/,' \
	| sed 's,/usr/vpnbridge/,/usr/local/softether/vpnbridge/,' \
	| sed 's,/usr/vpnclient/,/usr/local/softether/vpnclient/,' \
	| sed 's,/usr/vpncmd/,/usr/local/softether/vpncmd/,' \
	> Makefile

sudo make install
sudo vpnserver start
