# Audit trail

An intermediate **Linux hardening** challenge for [opslab](https://github.com/Sigeth) (working name): bring the audit daemon back and watch the account and sudo files, durably.

- Runtime: one `vm` machine built from `images/server` (a VM image recipe: the opslab-images Debian 13 base with `auditd`); `setup/setup.sh` disables auditing
- Checks: `shell`, which change each file's mode (to the same value) and look for the event with `ausearch`, then reload the rules from disk
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
