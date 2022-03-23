# SE_systemd

RU

Данный набор скриптов и конфигов предназначен для установки Softether (www.softether.org) и настройки сервисов для автоматического запуска.
Работа скриптов проверена под Ubuntu 20.04, для других Линуксов скрипты нужно править.
Исполнять скрипты можно из под любого пользователя с правами sudo.

Как пользоваться:
1. Для начала обновить имеющиеся пакеты

   sudo apt-get update && sudo apt-get upgrade -y
2. Установить GIT

   sudo apt install git
3. Клонировать репо

   git clone https://github.com/Paulus13/SE_systemd.git
4. cd SE_systemd

   chmod +x *.sh
   
   ./se_inst.sh
   
   Данный скрипт скачает и соберет из исходников последнюю на данный момент (март 2022) стабильную версию Softether https://github.com/SoftEtherVPN/SoftEtherVPN_Stable
   
   Так же скрипт включает IP-forwarding на уровне ОС.
   
   Пути установки отличаются от дефолтных, если нужно оставить дефолтные пути - закомментируйте в скрипте строки
      
      cp -p Makefile Makefile_bak
      cat Makefile_bak \
	      | sed 's,/usr/bin/,/usr/local/bin/,' \
	      | sed 's,/usr/vpnserver/,/usr/local/softether/vpnserver/,' \
	      | sed 's,/usr/vpnbridge/,/usr/local/softether/vpnbridge/,' \
	      | sed 's,/usr/vpnclient/,/usr/local/softether/vpnclient/,' \
	      | sed 's,/usr/vpncmd/,/usr/local/softether/vpncmd/,' \
	      > Makefile
5. Сделать первычные настройки Softether используя VPN Server Manager (скачать можно здесь https://www.softether-download.com/en.aspx?product=softether)

   Нужно установить пароль (будет запрошен при первом входе) и создать бридж для хаба Default, назвать его se0
   
   Local Bridge Settings - Virtual Hub - Default - Bridge with New Tap Device - se0 - Create Local Bridge.
   
   При этом на ОС появится сетевой интерфес tap_se0.
   
6. ./se_dhcp_systemd.sh

   Данный скрипт установит DHCP, а так же сконфигурирует DHCP и Softether как службы
   
7. Теперь можно настраивать VPN под свои нужды.
   
Немного о настройке iptables.

Чтобы получить доступ к VPN а так же чтобы он мог форвардить трафик наружу нужно добавить строки в iptables:

iptables -A INPUT -p tcp --dport 443 -j ACCEPT;

iptables -A INPUT -p tcp --dport 5555 -j ACCEPT;

iptables -A INPUT -p udp --dport 500 -j ACCEPT;

iptables -A INPUT -p udp --dport 1701 -j ACCEPT;

iptables -A INPUT -p udp --dport 4500 -j ACCEPT;

iptables -A INPUT -p 50 -j ACCEPT;

iptables -A INPUT -p 51 -j ACCEPT;

iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE;

iptables -A FORWARD -i tap_se0 -j ACCEPT;

iptables -A FORWARD -o tap_se0 -j ACCEPT;

Здесь так же разрешен входящий трафик по управляющим портам и портам для работы IPSec.
Интерфейс ens3 в строке MASQUERADE указан для примера, его нужно поменять на актуальный.

EN

This set of scripts and configs is designed to install Softether (www.softether.org) and service settings for automatic startup.
The scripts have been tested under Ubuntu 20.04, for other Linux you need to edit this scripts.
Scripts can be executed from under any user with sudo rights.

How to use:
1. To start, update the existing packages

    sudo apt-get update && sudo apt-get upgrade -y
    
2. Install GIT

   sudo apt install git

3. Clone the repo

   git clone https://github.com/Paulus13/SE_systemd.git

4. cd SE_systemd

   chmod +x *.sh

   ./se_inst.sh

   This script will download and compile from the source codes the latest stable version of Softether at the moment (March 2022).    https://github.com/SoftEtherVPN/SoftEtherVPN_Stable

The script also turn on IP forwarding at the OS level.

The installation paths are different from the default ones, if you need the default paths, comment out the lines in the script

cp -p Makefile Makefile_bak
cat Makefile_bak \
| sed 's,/usr/bin/,/usr/local/bin/,' \
| sed 's,/usr/vpnserver/,/usr/local/softether/vpnserver/,' \
| sed 's,/usr/vpnbridge/,/usr/local/softether/vpnbridge/,' \
| sed 's,/usr/vpnclient/,/usr/local/softether/vpnclient/,' \
| sed 's,/usr/vpncmd/,/usr/local/softether/vpncmd/,' \
> Makefile

5. Make initial Softether settings using VPN Server Manager (you can download it here https://www.softether-download.com/en.aspx?product=softether )

  You need to set a password (it will be requested at the first login) and create a bridge for the Default hub, call it se0

  Local Bridge Settings - Virtual Hub - Default - Bridge with New Tap Device - se0 - Create Local Bridge.

  At the same time, the tap_se0 network interface will appear on the OS.

6. ./se_dhcp_systemd.sh

   This script will install DHCP, as well as configure DHCP and Softether as services

7. Now you can configure VPN to suit your needs.

A little bit about setting up iptables.

To get access to the VPN and also so that it can forward traffic outside, you need to add some lines to iptables:

iptables -A INPUT -p tcp --dport 443 -j ACCEPT;

iptables -A INPUT -p tcp --dport 5555 -j ACCEPT;

iptables -A INPUT -p udp --dport 500 -j ACCEPT;

iptables -A INPUT -p udp --dport 1701 -j ACCEPT;

iptables -A INPUT -p udp --dport 4500 -j ACCEPT;

iptables -A INPUT -p 50 -j ACCEPT;

iptables -A INPUT -p 51 -j ACCEPT;

iptables -t nat -A POSTROUTING -o ens3 -j MASQUERADE;

iptables -A FORWARD -i tap_se0 -j ACCEPT;

iptables -A FORWARD -o tap_se0 -j ACCEPT;

Incoming traffic on control ports and ports for IPsec protocol is also allowed here.
The ens3 interface in the MASQUERADE line is specified for example, it needs to be changed to the current one.
