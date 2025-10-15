#!/bin/bash

# 1. Tambahkan repository MEGA
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:megacmd/ppa
sudo apt update

# 2. Install megacmd
sudo apt install -y megacmd

# 3. Jalankan daemon MEGA
mega-login sdnpengasinantujuh@gmail.com '@pgn7_2021@'

# 4. Validasi login
mega-whoami
