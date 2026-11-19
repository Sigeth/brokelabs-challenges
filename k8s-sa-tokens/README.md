# Stop leaking service account tokens

A beginner **Kubernetes** challenge for [BrokeLabs](https://github.com/Sigeth): pods that mount API tokens they never use.

- Runtime: a `vcluster` machine (Kubernetes 1.36) seeded from `setup/manifests`, and a `pod` workstation on the brokelabs-images `workstation-k8s` image
- Checks: `kubeCEL` on the pods' volumes (a token is a projected `serviceAccountToken` source)
- Solution: `solution/solve.sh`

## License

[MIT](../LICENSE)
