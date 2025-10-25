#!/bin/bash

# 1. Tambahkan repository MEGA
wget https://mega.nz/linux/repo/Debian_13/amd64/megacmd-Debian_13_amd64.deb && sudo apt install "$PWD/megacmd-Debian_13_amd64.deb"

# 2. Install megacmd
sudo apt install -y ./megacmd-Debian_13_amd64.deb
sudo apt --fix-broken install
echo "Veri Mega yg diinstal:"
mega-version

# 3. Jalankan daemon MEGA
mega-login sdnpengasinantujuh@gmail.com '@pgn7_2021@'

# 4. Validasi login
mega-whoami
