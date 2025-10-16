#!/bin/bash

# 1. Tambahkan repository Tailscale untuk Ubuntu Noble
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list

# 2. Update dan install Tailscale
sudo apt-get update
sudo apt-get install tailscale

sudo tailscale up

# 3. Enable dan start service Tailscale
sudo systemctl enable tailscaled
sudo systemctl start tailscaled