# Default-deny firewall

An intermediate **Linux hardening** challenge for [opslab](https://github.com/Sigeth) (working name): an nftables default-deny firewall that keeps SSH and a website open, hides an admin panel and a metrics endpoint, and survives a reboot.

- Runtime: one `vm` machine built from `images/server` (the opslab-images Debian 13 base with `nftables`); `setup/setup.sh` starts three services
- Checks: `http` and `port` probes from outside the machine, and `shell` (local access, boot configuration)
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
