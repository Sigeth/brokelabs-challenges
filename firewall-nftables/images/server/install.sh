#!/bin/sh
# nftables and its service, installed but not enabled: no firewall yet.
set -eu
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends nftables
systemctl disable nftables || true
apt-get clean
rm -rf /var/lib/apt/lists/*
