# sudoers cleanup

`sudo` rights on this server were handed out quickly and never reviewed:

- **intern** got full root "for the onboarding week", months ago.
- **backup** runs the nightly backup script as root, but it may also run `tar` as root, and `tar` can run any command. Anyone who becomes `backup` becomes root.

Fix it so that:

- `intern` **cannot use sudo at all**;
- `backup` **cannot run `tar` as root**, but **can still run** `/usr/local/bin/backup-home` as root;
- every sudoers file stays **valid**.

You have `sudo` yourself. Useful commands: `sudo -l -U <user>`, `sudo visudo -f /etc/sudoers.d/<file>`, `sudo visudo -c`, `ls -l /etc/sudoers.d/`.

Leave `/etc/sudoers.d/90-cloud-init-users` alone: it holds your rights and those of `opslab-checker`, the account that checks your work. Without them, checks fail.
