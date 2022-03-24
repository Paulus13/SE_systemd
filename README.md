# SE_systemd

git clone https://github.com/Paulus13/SE_systemd.git

cd SE_systemd

chmod +x *.sh

./se_inst.sh
   
Сделать первичные настройки Softether используя VPN Server Manager (скачать можно здесь https://www.softether-download.com/en.aspx?product=softether)
Нужно установить пароль (будет запрошен при первом входе) и создать бридж для хаба Default, назвать его se0.
Local Bridge Settings - Virtual Hub - Default - Bridge with New Tap Device - se0 - Create Local Bridge.

./se_dhcp_systemd.sh
