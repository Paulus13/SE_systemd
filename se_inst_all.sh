#!/bin/bash

#	Script for install Softether
#	Works with Ubuntu 18.04 and higher

NET_FORWARD="net.ipv4.ip_forward=1"
sudo sysctl -w  ${NET_FORWARD}
sudo sed -i "s,#${NET_FORWARD},${NET_FORWARD}," /etc/sysctl.conf

sudo apt -y install cmake gcc g++ make libncurses5-dev libssl-dev libsodium-dev libreadline-dev zlib1g-dev git
wget softether-src.tar.gz https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.38-9760-rtm/softether-src-v4.38-9760-rtm.tar.gz
tar -xvf softether-src-v4.38-9760-rtm.tar.gz
rm softether-src-v4.38-9760-rtm.tar.gz
cd v4.38-9760
./configure
make

sed -i 's,/usr/bin/,/usr/local/bin/,' Makefile
sed -i 's,/usr/vpnserver/,/usr/local/softether/vpnserver/,' Makefile
sed -i 's,/usr/vpnbridge/,/usr/local/softether/vpnbridge/,' Makefile
sed -i 's,/usr/vpnclient/,/usr/local/softether/vpnclient/,' Makefile
sed -i 's,/usr/vpncmd/,/usr/local/softether/vpncmd/,' Makefile

sudo make install
sudo vpnserver start

read -p "Enter the password for SoftetherVPN ([ENTER] set to default: VPN-8888 ): " VPN_PASSWORD
if [ -z $VPN_PASSWORD ]
then
  VPN_PASSWORD='VPN-8888'
fi

sudo vpncmd 127.0.0.1:5555 /SERVER /CMD ServerPasswordSet $VPN_PASSWORD
sudo vpncmd 127.0.0.1:5555 /SERVER /PASSWORD:$VPN_PASSWORD /CMD BridgeCreate DEFAULT /DEVICE:se0 /TAP:yes

sudo apt -y install isc-dhcp-server unzip
 
sudo systemctl stop isc-dhcp-server
sudo systemctl stop isc-dhcp-server6
sudo systemctl disable isc-dhcp-server
sudo systemctl disable isc-dhcp-server6

if [ ! -e dhcp_conf.zip ]
then
	wget https://github.com/Paulus13/se_install/raw/main/dhcp_conf.zip
fi

unzip dhcp_conf.zip

sudo cp /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server.orig
sudo cp isc-dhcp-server /etc/default/

sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.orig
sudo cp dhcpd.conf /etc/dhcp/

sudo systemctl stop isc-dhcp-server.service
sudo vpnserver stop

if [ ! -e softether-systemd.zip ]
then
	wget https://github.com/Paulus13/se_install/raw/main/softether-systemd.zip
fi

unzip softether-systemd.zip
rm softether-systemd.zip

sudo install -m 755 vpnserver-env /usr/local/softether/vpnserver
sudo install -m 755 post-start.sh /usr/local/softether/vpnserver
sudo install -m 755 post-stop.sh /usr/local/softether/vpnserver

sudo install -m 644 isc-dhcp-server.service /lib/systemd/system
sudo install -m 644 softether-vpnserver.service /lib/systemd/system

sudo systemctl daemon-reload

sudo systemctl start softether-vpnserver.service
sudo systemctl start isc-dhcp-server.service

sudo systemctl enable isc-dhcp-server.service
sudo systemctl enable softether-vpnserver.service


