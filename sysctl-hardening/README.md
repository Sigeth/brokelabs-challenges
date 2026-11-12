# Kernel parameters

A beginner **Linux hardening** challenge for [opslab](https://github.com/Sigeth) (working name): unsafe `sysctl` settings left over from a lab network, to fix both live and persistently.

- Runtime: one `vm` machine, the opslab-images Debian 13 base as is; `setup/setup.sh` writes and applies the bad settings
- Checks: `shell`, which first applies the configuration files (as a boot does), then reads the live values
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
