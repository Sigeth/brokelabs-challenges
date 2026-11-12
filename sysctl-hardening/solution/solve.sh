#!/bin/sh
# Reference solution (teachers only), as student with sudo.
set -eu
sudo rm /etc/sysctl.d/60-lab-network.conf
sudo tee /etc/sysctl.d/90-hardening.conf >/dev/null <<'CONF'
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
fs.protected_symlinks = 1
fs.protected_hardlinks = 1
CONF
sudo sysctl --system >/dev/null
