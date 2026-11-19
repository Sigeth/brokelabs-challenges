#!/bin/sh
# Reference solution: no token for the default service account's pods (api
# and worker); the reporter has its own account and keeps its token.
set -eu
kubectl -n payments patch serviceaccount default -p '{"automountServiceAccountToken": false}'
kubectl -n payments rollout restart deployment api worker
kubectl -n payments rollout status deployment api worker --timeout=120s
