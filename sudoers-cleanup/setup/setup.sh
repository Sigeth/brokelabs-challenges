#!/bin/sh
# Runs as root when the instance starts: sudo rights granted the easy way.
set -eu

useradd --create-home --shell /bin/bash intern
# Debian already has a "backup" system account: the job runs as it.
id backup >/dev/null 2>&1 || useradd --system backup

# The nightly backup: archives the home directories into /var/backups.
cat > /usr/local/bin/backup-home <<'SCRIPT'
#!/bin/sh
# Archives /home into /var/backups (run as root by the backup account).
set -eu
tar -czf "/var/backups/home-$(date +%Y%m%d).tar.gz" -C / home 2>/dev/null
echo "backup written to /var/backups"
SCRIPT
chmod 0755 /usr/local/bin/backup-home

cat > /etc/sudoers.d/intern <<'SUDO'
# Temporary, for the onboarding week.
intern ALL=(ALL) NOPASSWD: ALL
SUDO
cat > /etc/sudoers.d/backup <<'SUDO'
# The backup job needs to read every home directory.
backup ALL=(root) NOPASSWD: /usr/bin/tar, /usr/local/bin/backup-home
SUDO
chmod 0440 /etc/sudoers.d/intern /etc/sudoers.d/backup
visudo -c >/dev/null
