#!/bin/sh
# Reference solution, step 2 (worker): join with the token of step 1, then run
# a pod on the worker. The CA hash is skipped because this script cannot copy
# it from the control plane; a student uses the full join command.
set -eu
sudo kubeadm join cp:6443 --token abcdef.0123456789abcdef \
  --discovery-token-unsafe-skip-ca-verification --node-name worker >/dev/null
pause=$(sudo crictl images -o json | grep -o 'registry.k8s.io/pause:[^"]*' | head -1)
# The worker has no admin kubeconfig: a static pod is the simplest workload
# (its mirror pod shows on the API in the default namespace).
sudo sh -c "cat > /etc/kubernetes/manifests/web.yaml" <<YAML
apiVersion: v1
kind: Pod
metadata: {name: web, namespace: default}
spec:
  containers: [{name: web, image: $pause}]
YAML
for _ in $(seq 60); do
  [ -n "$(sudo crictl ps --name web --state running -q)" ] && exit 0
  sleep 2
done
echo "the web pod is not running" >&2
exit 1
