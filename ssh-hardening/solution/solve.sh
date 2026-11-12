#!/bin/sh
# Reference solution (teachers only), as student with sudo.
set -eu
sudo rm /etc/ssh/sshd_config.d/10-legacy.conf
sudo tee /etc/ssh/sshd_config.d/00-hardening.conf >/dev/null <<'CONF'
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
CONF
sudo sshd -t
sudo systemctl reload ssh
