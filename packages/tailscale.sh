#!/bin/bash

# 1. Install dengan One command install dari tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# 2. Jalankan daemon Tailscale
sudo tailscale up

# 3. Enable dan start service Tailscale
sudo systemctl enable tailscaled
sudo systemctl start tailscaled