#!/bin/bash

#	Script for install DHCP and configure autostart for Softether and DHCP
#	Works with Ubuntu 18.04 and higher


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
#rm softether-systemd.zip

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
