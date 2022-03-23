# SE_systemd

RU

Данный набор скриптов и конфигов предназначен для установки Softether (www.softether.org) и настройки сервисв для автоматического запуска.
Работа скриптов проверена под Ubuntu 20.04, для других Линуксов скрипты нужно править

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
6. 
   Нужно установить пароль (будет запрошен при первом входе) и создать бридж для хаба Default, назвать его se0
   
   Local Bridge Settings - Virtual Hub - Default - Bridge with New Tap Device - se0 - Create Local Bridge.
   
   При этом на ОС появится сетевой интерфес tap_se0.
6. ./se_dhcp_systemd.sh
   Данный скрипт установит DHCP, а так же сконфигурирует DHCP и Softether как службы
   
Чтобы VPN мог форвардить трафик наружу нужно добавить строки в iptables:

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
