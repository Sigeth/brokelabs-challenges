# Least privilege for a CI service account

The CI pipeline deploys new versions of the `web` application in the `apps` namespace, using the `ci-deployer` service account of the `ci` namespace. When the pipeline was set up, its permissions "did not work", so someone made it a **cluster administrator**. Anyone who steals the pipeline's token now owns the cluster, including the database password stored in `apps`.

Your terminal is a workstation with `kubectl`, connected to the cluster as an administrator. `kubectl auth can-i ... --as=system:serviceaccount:ci:ci-deployer` tells you what the account may do.

## Your tasks

1. `ci-deployer` must not be a cluster administrator any more.
2. It must not read secrets, not even in `apps`.
3. It must not change deployments outside `apps`.

The pipeline must keep working: `ci-deployer` still needs to get, list, watch, patch and update deployments in `apps`, and to list its pods.
