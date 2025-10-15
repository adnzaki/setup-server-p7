#!/bin/bash

# 1. Tambahkan repository Tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list > /dev/null

# 2. Update dan install Tailscale
sudo apt update
sudo apt install -y tailscale

# 3. Enable dan start service Tailscale
sudo systemctl enable tailscaled
sudo systemctl start tailscaled

# 4. Login ke Tailscale (akan buka URL untuk otentikasi)
sudo tailscale up