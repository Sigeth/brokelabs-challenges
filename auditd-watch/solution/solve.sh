#!/bin/sh
# Reference solution (teachers only), as student with sudo.
set -eu
# 00-flush.rules (-D) stays: it clears the rules before the files are loaded.
sudo tee /etc/audit/rules.d/50-identity.rules >/dev/null <<'RULES'
-w /etc/shadow -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/sudoers -p wa -k privileges
-w /etc/sudoers.d/ -p wa -k privileges
RULES
sudo systemctl enable --now auditd
sudo augenrules --load
