#!/bin/bash
sudo apt-get install iptables-persistent -y
sudo iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
sudp iptables -I INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 300 --hitcount 4 -j DROP
# save iptables rules
sudo iptables-save > /etc/iptables/rules.v4