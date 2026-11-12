#!/bin/sh
# The audit daemon and its tools (auditctl, ausearch, augenrules).
set -eu
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends auditd
apt-get clean
rm -rf /var/lib/apt/lists/*
