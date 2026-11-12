#!/bin/sh
# Runs as root when the instance starts: kernel settings from a lab network.
set -eu
cat > /etc/sysctl.d/60-lab-network.conf <<'CONF'
# Lab network tuning (routing tests, debugging).
net.ipv4.ip_forward = 1
net.ipv4.conf.all.accept_redirects = 1
net.ipv4.conf.default.accept_redirects = 1
net.ipv4.conf.all.send_redirects = 1
kernel.kptr_restrict = 0
kernel.dmesg_restrict = 0
fs.protected_symlinks = 0
fs.protected_hardlinks = 0
CONF
/usr/lib/systemd/systemd-sysctl
