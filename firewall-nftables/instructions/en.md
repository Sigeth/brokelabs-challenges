# Default-deny firewall

This server runs three services and has no firewall at all:

| Port | Service | Who should reach it |
|---|---|---|
| 22 | SSH | everyone (you, and the platform checking your work) |
| 80 | public website | everyone |
| 8080 | internal admin panel | **only the server itself** |
| 9100 | metrics endpoint left on after debugging | **nobody** from the network |

Write an **nftables** firewall:

- **default deny**: the input chain drops whatever is not explicitly allowed;
- **SSH (22) and the website (80) stay reachable** from the network;
- the admin panel keeps **working locally** (`curl http://127.0.0.1:8080/`), but is **unreachable** from the network;
- the firewall is **loaded at boot**.

Keep port 22 open: if you block it, you lock yourself and the checks out (they connect over SSH). Test your rules with `sudo nft -c -f FILE` before loading them.

Useful commands: `sudo nft list ruleset`, `sudo nft -f /etc/nftables.conf`, `sudo systemctl enable nftables`, `ss -tlnp`.
