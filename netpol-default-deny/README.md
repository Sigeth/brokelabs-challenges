# Default-deny network policies

A **Kubernetes** NetworkPolicy challenge for [BrokeLabs](https://github.com/Sigeth): a three-tier namespace to isolate with a default-deny policy and explicit allows.

- Runtime: a `vcluster` machine (Kubernetes 1.36, NetworkPolicies enforced on the host) seeded from `setup/manifests`, and a `pod` workstation on the brokelabs-images `workstation-k8s` image
- Checks: `kubeCEL` for the default-deny policy; real connections between the pods through `kubectl exec` for the rest (refused paths by pod IP)
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
