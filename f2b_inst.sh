#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt install -y fail2ban

cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local 

sed -i "s:bantime  = 10m:bantime  = 1440h:" /etc/fail2ban/jail.local
sed -i "s:findtime  = 10m:findtime  = 120m:" /etc/fail2ban/jail.local
sed -i "s:maxretry = 5:maxretry = 2:" /etc/fail2ban/jail.local

cat > /etc/fail2ban/filter.d/vpnserver.conf << EOF
# Fail2Ban filter for SoftEther authentication failures
# Made by quixrick and Nobody
# Thanks to quixrick from Reddit! https://reddit.com/u/quixrick
# Further reference: http://www.vpnusers.com/viewtopic.php?f=7&t=6375&sid=76707e8a5a16b0c9486a39ba34763901&view=print

[INCLUDES]

# Read common prefixes. If any customizations available -- read them from
# common.local
before = common.conf

#Enable multi line support. Doesn't work with versions < 0.9
[Init]
maxlines = 2 
# The regular expression filter follows
[Definition]

failregex =IP address: <HOST>.*\n.*User authentication failed.*
ignoreregex=
EOF

cat >> /etc/fail2ban/jail.local << EOF

[vpnserver-udp]
port = 500,1701,4500
enabled = true
protocol = udp
filter = vpnserver
logpath = /usr/local/softether/vpnserver/security_log/*/sec_*.log

[vpnserver-tcp]
port = 443, 5555
enabled = true
protocol = tcp
filter = vpnserver
logpath = /usr/local/softether/vpnserver/security_log/*/sec_*.log

EOF

systemctl restart fail2ban.service 
