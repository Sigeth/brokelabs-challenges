# sudoers cleanup

An intermediate **Linux hardening** challenge for [opslab](https://github.com/Sigeth) (working name): a forgotten full-root grant and a `tar` sudo rule that is a root shell in disguise.

- Runtime: one `vm` machine, the opslab-images Debian 13 base as is; `setup/setup.sh` adds the accounts and rules
- Checks: `shell` (`sudo -l -U`, `visudo -c`, running the backup as the backup account)
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
