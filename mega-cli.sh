#!/bin/bash

# 1. Tambahkan repository MEGA
wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd_1.6.7-1_amd64.deb

# 2. Install megacmd
sudo apt install -y ./megacmd_1.6.7-1_amd64.deb
sudo apt --fix-broken install
echo "Veri Mega yg diinstal:"
mega-version

# 3. Jalankan daemon MEGA
mega-login sdnpengasinantujuh@gmail.com '@pgn7_2021@'

# 4. Validasi login
mega-whoami
