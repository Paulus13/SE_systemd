# SE_systemd

Made for personal use. 
The instruction is as short as possible. 
Configure the firewall yourself. 

git clone https://github.com/Paulus13/se_install.git

cd se_install

chmod +x *.sh

./se_inst.sh
   
Make initial Softether settings using VPN Server Manager (https://www.softether-download.com/en.aspx?product=softether ). Set a password (it will be requested at the first login) and create a bridge for the Default hub, call it se0. 

Local Bridge Settings - Virtual Hub - Default - Bridge with New Tap Device - se0 - Create Local Bridge.

./se_dhcp_systemd.sh
