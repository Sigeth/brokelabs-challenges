# Join a worker to a kubeadm cluster

A team installed a Kubernetes control plane with **kubeadm** on `cp`, but the second machine, `worker`, never joined. Both machines run Kubernetes 1.36 with containerd, and every image the cluster needs is already on them: they have no Internet access.

You have a terminal on each machine, as `student` with `sudo`. On `cp`, `kubectl` already works with the cluster's admin configuration.

## Your tasks

1. Join `worker` to the cluster, so that `kubectl get nodes` shows it **Ready**.
2. Run a pod on `worker`. Any image already present on the node will do.

Keep the control plane healthy while you work.
