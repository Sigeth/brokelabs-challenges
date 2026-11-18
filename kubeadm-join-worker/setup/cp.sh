#!/bin/sh
# Creates the control plane: kubeadm init with flannel's pod network, and a
# kubeconfig for the student. Runs as root, once.
set -eu
systemctl start brokelabs-k8s-images # waits for the preloaded images
if ! kubeadm init --kubernetes-version "v$(cat /etc/brokelabs/kubernetes-version)" \
  --pod-network-cidr 10.244.0.0/16 --node-name cp --skip-token-print >/var/log/kubeadm-init.log 2>&1; then
  tail -n 25 /var/log/kubeadm-init.log >&2
  exit 1
fi
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f /etc/brokelabs/kube-flannel.yml >/dev/null
install -d -o student -g student /home/student/.kube
install -m 0600 -o student -g student /etc/kubernetes/admin.conf /home/student/.kube/config
kubectl wait --for=condition=Ready node/cp --timeout=180s >/dev/null
