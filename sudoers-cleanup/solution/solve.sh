#!/bin/sh
# Reference solution (teachers only), as student with sudo.
set -eu
sudo rm /etc/sudoers.d/intern
echo 'backup ALL=(root) NOPASSWD: /usr/local/bin/backup-home ""' | sudo tee /etc/sudoers.d/backup >/dev/null
sudo chmod 0440 /etc/sudoers.d/backup
sudo visudo -c
