#!/bin/bash

# install fail2ban
sudo apt-get install fail2ban -y

# check if status of fail2ban is active
if [ $(systemctl is-active fail2ban) == "active" ]; then
    echo "Fail2ban is active"
else
    echo "Fail2ban is not active"
    systemctl start fail2ban
fi

# copy jail.local to /etc/fail2ban/jail.local
sudo cp jail.local /etc/fail2ban/jail.local

# protect ssh with fail2ban
sudo fail2ban-client reload sshd

