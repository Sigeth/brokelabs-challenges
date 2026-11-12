# Kernel parameters

This server was once used for routing experiments on a lab network. Its kernel settings were never restored: it forwards packets, follows ICMP redirects, shows kernel addresses and its log to everyone, and the protections against `/tmp` link attacks are off.

Restore safe values:

| Setting | Safe value |
|---|---|
| `net.ipv4.ip_forward` | `0` |
| `net.ipv4.conf.{all,default}.accept_redirects`, `net.ipv4.conf.all.send_redirects` | `0` |
| `kernel.kptr_restrict` | `1` or `2` |
| `kernel.dmesg_restrict` | `1` |
| `fs.protected_symlinks`, `fs.protected_hardlinks` | `1` |

The values must be right **now and after a reboot**: the checks apply the configuration files the way a boot does, then read the live values. `sysctl -w` alone is lost at the next boot; a file alone does nothing until it is applied.

Useful commands: `sysctl -a`, `sudo sysctl -w key=value`, `ls /etc/sysctl.d/`, `sudo sysctl --system` (applies every file, in order: the last value wins).
