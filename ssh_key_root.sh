#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as ROOT"
  exit
fi

if ! [ -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
fi

cat > ~/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArFltQbO7/MmKzGeIelQrHBeIvdtdQZJfeT9qjIfV9cKf9w6z2eGm2eKPIjGumHcRza1yhCi8zmmnVbOniyLCbzpGlGl1hNy8sLrRxEDEYIHteug+i55lOP6D4Mnodmcry3zCpRA0AZvcV5cuPCSVJLAcCQEiQIKPmi9KhqldUOVHUxK0SNL+Qpp28iEL6pwWfep4DifQ7qcXGj/MgnlNTiRRoKLZDIxJ1Nh7JW8eV0mPykyEPMEk4o+XVFVM3LAZRZcJ6s+Od+CipdZ0HORB20qGJaEKo7IhZ7isQzpY66mG7sEPqZVumTuyayglj0tl92RWv3y0D2iXOrccsG928Q== OpenSSH-rsa-import-071018
EOF

chmod 600 ~/.ssh/authorized_keys

sed -i 's,#PasswordAuthentication yes,PasswordAuthentication no,' /etc/ssh/sshd_config
sed -i 's,PasswordAuthentication yes,PasswordAuthentication no,' /etc/ssh/sshd_config

systemctl reload sshd
