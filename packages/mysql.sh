#!/bin/bash

# 1. Install MariaDB Server
sudo apt update
sudo apt install -y mariadb-server

# 2. Enable dan jalankan service MariaDB
sudo systemctl enable mariadb
sudo systemctl start mariadb

# 3. Jalankan setup keamanan awal
sudo mysql_secure_installation

# - Set root password (boleh kosong jika pakai socket auth)
# - Remove anonymous users → Yes
# - Disallow remote root login → Yes
# - Remove test database → Yes
# - Reload privilege tables → Yes
