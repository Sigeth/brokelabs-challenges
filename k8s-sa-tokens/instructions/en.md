# Stop leaking service account tokens

The `payments` namespace runs three workloads: `api`, `worker` and `reporter`. Kubernetes gives every pod a token for its service account by default, and anyone who gets a shell in `api` or `worker` could use theirs against the API. Neither of them ever talks to Kubernetes.

Your terminal is a workstation with `kubectl`, connected to the cluster as an administrator.

## Your tasks

1. The `api` and `worker` pods must not mount a service account token any more.
2. `reporter` really reads the API: it must keep its token.

Keep both deployments running.
