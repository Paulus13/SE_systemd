#!/bin/bash

if (( $EUID = 0 )); then
    echo "Please run as NO ROOT"
    exit
fi

if ! [ -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
fi

cat > ~/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEArynSGTNExbKv7Xl04r/AhEKCC2BwPOE3jw4496enPTCI1x0/mpJDjrFf/DBD6a51Ae5oV2afjX8YVe/FhfK5Y3BH6TYC8C/4SJITu5TuYxO7LG/X70DB33AqdQtCyaaOSR+xjUimgfR41357dgiUS78hstqABlP1Glq0eJdpLUthijKY3xrgbOqKrYECmhPalqgB/kLpBEZ9s/YuJf/kdCgAbi9lAGqddN/B9vtHs/ak87S/0+jv1KVf+oMR+PbAakWBAahrNYe4oXQX7zJzeJmjc073czYdxTabfxY7Z/xFCr3dsK0rZKITIqwzO0MEzIbSwweHyVyBa/qluM8fyQ== OpenSSH-rsa-import-080918
EOF

chmod 600 ~/.ssh/authorized_keys

sudo sed -i 's,#PasswordAuthentication yes,PasswordAuthentication no,' /etc/ssh/sshd_config
sudo sed -i 's,PasswordAuthentication yes,PasswordAuthentication no,' /etc/ssh/sshd_config

sudo systemctl reload sshd
