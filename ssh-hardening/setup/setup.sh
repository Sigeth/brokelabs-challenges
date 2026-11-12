#!/bin/sh
# Runs as root when the instance starts: an sshd configured for convenience.
set -eu

# A deployment account someone created with a guessable password.
useradd --create-home --shell /bin/bash deploy
echo 'deploy:deploy123' | chpasswd

# Root accepts the student's key (copied "to make administration easier").
install -d -m 700 /root/.ssh
cp /home/student/.ssh/authorized_keys /root/.ssh/authorized_keys

cat > /etc/ssh/sshd_config.d/10-legacy.conf <<'CONF'
# Added during the migration, "temporarily".
PermitRootLogin yes
PasswordAuthentication yes
KbdInteractiveAuthentication yes
CONF
systemctl reload ssh
