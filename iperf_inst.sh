#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt install -y iperf3

cat > /etc/systemd/system/iperfd.service << EOF
[Unit]
Description=iPerf Service
After=network.target

[Service]
Type=forking
PIDFile=/run/iperf3.pid
ExecStart=-/usr/bin/iperf3 -s -p 5202 -D -I /run/iperf3.pid
ExecReload=/bin/kill -HUP $MAINPID
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable iperfd
systemctl start iperfd
