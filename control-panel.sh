#!/bin/bash

# 1. Install dependencies
sudo apt update
sudo apt install -y software-properties-common apt-transport-https curl gnupg2

# 2. Install Webmin (versi aman untuk Ubuntu Noble)
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sudo sh webmin-setup-repo.sh
sudo apt update
sudo apt install -y webmin

# 3. Install Cockpit
sudo apt install -y cockpit

# 3. Install Cockpit Navigator for file browser
wget https://github.com/45Drives/cockpit-navigator/releases/download/v0.5.10/cockpit-navigator_0.5.10-1focal_all.deb
sudo apt install ./cockpit-navigator_0.5.10-1focal_all.deb

# 4. Enable dan jalankan service Webmin & Cockpit
sudo systemctl enable webmin
sudo systemctl start webmin

sudo systemctl enable cockpit
sudo systemctl start cockpit

sudo ufw allow 10000/tcp
sudo ufw allow 9090/tcp