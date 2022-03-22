#!/bin/bash

#	Script for install DHCP and configure autostart for Softether and DHCP
#	Works with Ubuntu 18.04 and higher


sudo apt -y install isc-dhcp-server unzip
 
sudo systemctl stop isc-dhcp-server
sudo systemctl stop isc-dhcp-server6
sudo systemctl disable isc-dhcp-server
sudo systemctl disable isc-dhcp-server6

sudo cp -p /etc/default/isc-dhcp-server /etc/default/isc-dhcp-server_bak
sudo cat /etc/default/isc-dhcp-server_bak \
| sed 's,INTERFACESv4="",INTERFACESv4="tap_se0",' \
| sed 'INTERFACESv6="",INTERFACESv6="tap_se0",' \
> /etc/default/isc-dhcp-server

cat << \! >> /etc/dhcp/dhcpd.conf

subnet 10.5.1.0 netmask 255.255.255.0 {
  range 10.5.1.50 10.5.1.230;
  option domain-name-servers 1.1.1.1;
  option domain-name "my-host.example.org";
  option subnet-mask 255.255.255.0;
  option routers 10.5.1.1;
  default-lease-time 600;
  max-lease-time 7200;
}

!

sudo systemctl stop isc-dhcp-server.service
sudo vpnserver stop

if [ ! -e softether-systemd.zip ]
then
	wget https://github.com/Paulus13/SE_systemd/raw/main/softether-systemd.zip
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

sudo systemctl status isc-dhcp-server.service
sudo systemctl status softether-vpnserver.service

sudo systemctl enable isc-dhcp-server.service
sudo systemctl enable softether-vpnserver.service
