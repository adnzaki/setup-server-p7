#!/bin/bash

# 1. Tambahkan repository MEGA
wget https://mega.nz/linux/repo/xUbuntu_24.04/amd64/megacmd-xUbuntu_24.04_amd64.deb && sudo apt install "$PWD/megacmd-xUbuntu_24.04_amd64.deb"

# 2. Install megacmd
echo "Veri Mega yg diinstal:"
mega-version

# 3. Jalankan daemon MEGA
mega-login sdnpengasinantujuh@gmail.com '@pgn7_2021@'

# 4. Validasi login
mega-whoami
