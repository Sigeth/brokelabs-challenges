# SSH hardening

This server's SSH daemon was configured for convenience during a migration and never cleaned up. Anyone who gets hold of a key or guesses a password can now walk in, including as **root**.

Harden `sshd` so that:

- **root cannot log in** over SSH, even with a valid key;
- **passwords are refused**: only key-based logins work (the `deploy` account has a weak password);
- **you can still log in** as `student` with your key.

You have `sudo`. Useful commands: `sudo sshd -T` (the effective configuration), `sudo sshd -t` (check before reloading), `sudo systemctl reload ssh`, `ls /etc/ssh/sshd_config.d/`.

Be careful: a broken configuration locks everyone out. Check it before reloading and keep this terminal open while you test.

Each task is checked by trying real logins from outside your machine. Stopping `sshd` does not count as refusing logins.
