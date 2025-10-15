#!/bin/bash

# 1. Install dependencies
sudo apt update
sudo apt install -y software-properties-common apt-transport-https curl gnupg2

# 2. Install Webmin
curl -fsSL https://download.webmin.com/jcameron-key.asc | sudo gpg --dearmor -o /usr/share/keyrings/webmin.gpg
echo "deb [signed-by=/usr/share/keyrings/webmin.gpg] https://download.webmin.com/download/repository sarge contrib" | sudo tee /etc/apt/sources.list.d/webmin.list
sudo apt update
sudo apt install -y webmin

# 3. Install Cockpit
sudo apt install -y cockpit

# 4. Enable dan jalankan service Webmin & Cockpit
sudo systemctl enable webmin
sudo systemctl start webmin

sudo systemctl enable cockpit
sudo systemctl start cockpit

sudo ufw allow 10000/tcp
sudo ufw allow 9090/tcp