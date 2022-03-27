#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt install -y unattended-upgrades apt-listchanges

sed -i "s,//Unattended-Upgrade::Remove-Unused-Kernel-Packages \"true\";,Unattended-Upgrade::Remove-Unused-Kernel-Packages \"true\";," /etc/apt/apt.conf.d/50unattended-upgrades 
sed -i "s,//Unattended-Upgrade::Remove-New-Unused-Dependencies \"true\";,Unattended-Upgrade::Remove-New-Unused-Dependencies \"true\";," /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s,//Unattended-Upgrade::Remove-Unused-Dependencies \"false\";,Unattended-Upgrade::Remove-Unused-Dependencies \"true\";," /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s,//Unattended-Upgrade::Automatic-Reboot \"false\";,Unattended-Upgrade::Automatic-Reboot \"true\";," /etc/apt/apt.conf.d/50unattended-upgrades 
sed -i "s,//Unattended-Upgrade::Automatic-Reboot-WithUsers \"true\";,Unattended-Upgrade::Automatic-Reboot-WithUsers \"true\";," /etc/apt/apt.conf.d/50unattended-upgrades
sed -i "s,//Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";,Unattended-Upgrade::Automatic-Reboot-Time \"02:00\";," /etc/apt/apt.conf.d/50unattended-upgrades

dpkg-reconfigure -plow unattended-upgrades

systemctl restart unattended-upgrades.service
