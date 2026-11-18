#!/bin/sh
# Reference solution, step 1 (control plane): a bootstrap token the worker
# step knows. A student would copy `kubeadm token create --print-join-command`.
set -eu
sudo kubeadm token create abcdef.0123456789abcdef --ttl 1h >/dev/null
