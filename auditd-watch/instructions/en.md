# Audit trail

On this server, nothing records who changes the user accounts or the `sudo` rules. Someone switched the audit daemon off "for performance" and deleted its rules: an attacker could add an account or a sudo rule and leave no trace.

Turn auditing back on:

- the audit daemon **runs and starts at boot**;
- every change to **`/etc/shadow`**, **`/etc/passwd`** and **`/etc/sudoers`** (writes and attribute changes such as `chmod`) is **recorded**;
- the rules are **persistent**: they come back when the rules are loaded from disk, as at boot.

Each check makes a harmless change to the file (it sets its mode to the same value) and looks for the event with `ausearch`.

Useful commands: `sudo systemctl enable --now auditd`, `sudo auditctl -l`, `sudo auditctl -w <path> -p wa -k <key>`, `ls /etc/audit/rules.d/`, `sudo augenrules --load`, `sudo ausearch -k <key>`.
