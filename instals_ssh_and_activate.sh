#!/bin/bash

# install openssh-server with -y flag to skip confirmation
sudo apt-get install openssh-server -y

# check if status of ssh is active
if [ $(systemctl is-active ssh) == "active" ]; then
    echo "SSH is active"
else
    echo "SSH is not active"
    systemctl start ssh
fi
