#!/bin/sh
# Reference solution (teachers only), as student with sudo.
set -eu
sudo tee /etc/nftables.conf >/dev/null <<'NFT'
#!/usr/sbin/nft -f
flush ruleset

table inet filter {
	chain input {
		type filter hook input priority filter; policy drop;
		iif lo accept
		ct state established,related accept
		ct state invalid drop
		meta l4proto { icmp, ipv6-icmp } accept
		tcp dport { 22, 80 } accept
	}
	chain forward {
		type filter hook forward priority filter; policy drop;
	}
	chain output {
		type filter hook output priority filter; policy accept;
	}
}
NFT
sudo nft -c -f /etc/nftables.conf
sudo systemctl enable nftables
sudo nft -f /etc/nftables.conf
