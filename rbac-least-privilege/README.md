# Least privilege for a CI service account

A **Kubernetes** RBAC challenge for [BrokeLabs](https://github.com/Sigeth): a CI service account bound to `cluster-admin`, to scope down to one namespace.

- Runtime: a `vcluster` machine (Kubernetes 1.36) seeded from `setup/manifests`, and a `pod` workstation on the brokelabs-images `workstation-k8s` image
- Checks: shell checks on the workstation with `kubectl auth can-i --as=...` (the API answers, not the RBAC objects, so any correct design passes)
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
