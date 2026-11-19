# Default-deny network policies

The `shop` namespace runs three tiers: `frontend` (port 80), `api` (port 8080) and `db` (port 5432). Kubernetes lets every pod talk to every other one, so anything that compromises the frontend can talk to the database directly.

Your terminal is a workstation with `kubectl`, connected to the cluster as an administrator. Test a path with `kubectl -n shop exec deploy/frontend -- wget -qO- -T3 http://api:8080/`.

## Your tasks

1. Deny all incoming traffic in `shop` by default.
2. The database accepts connections from the `api` only.
3. The `api` accepts connections from the `frontend` only.

The application must keep working: `frontend` reaches `api`, and `api` reaches `db`.

On this platform, a policy rule must name its peers with pod selectors (or namespace selectors): rules that allow "everything" or IP ranges are refused, and `kubectl get events` explains why.
