# Join a worker to a kubeadm cluster

A CKA-style **Kubernetes** challenge for [BrokeLabs](https://github.com/Sigeth): a kubeadm control plane and a worker to join.

- Runtime: two `vm` machines on the brokelabs-images `kubeadm-1.36` image (containerd, kubeadm and the cluster's images preloaded); they get bridge networking, so each node has its own IP
- Setup: `setup/cp.sh` runs `kubeadm init` with flannel; `setup/worker.sh` only imports the images
- Checks: shell checks as root on the control plane, through its admin kubeconfig
- Solution: `solution/cp.sh` then `solution/worker.sh`

## License

[MIT](../LICENSE)
