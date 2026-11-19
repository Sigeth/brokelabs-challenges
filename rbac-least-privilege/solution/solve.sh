#!/bin/sh
# Reference solution: a Role in apps with what a rollout needs, bound to
# ci-deployer, and no more cluster-admin binding.
set -eu
kubectl apply -f - <<'YAML'
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata: {name: deployer, namespace: apps}
rules:
  - {apiGroups: [apps], resources: [deployments], verbs: [get, list, watch, patch, update]}
  - {apiGroups: [""], resources: [pods], verbs: [get, list, watch]}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata: {name: ci-deployer, namespace: apps}
roleRef: {apiGroup: rbac.authorization.k8s.io, kind: Role, name: deployer}
subjects:
  - {kind: ServiceAccount, name: ci-deployer, namespace: ci}
YAML
kubectl delete clusterrolebinding ci-deployer-admin
