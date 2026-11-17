# BrokeLabs challenges

The official challenges of [BrokeLabs](https://github.com/Sigeth), a self-hosted platform of hands-on DevOps security challenges.

| Challenge | Category | Difficulty | Machines |
|---|---|---|---|
| [leaky-home](leaky-home) | Linux hardening | easy | 1 `pod` |
| [exposed-debug-port](exposed-debug-port) | Containers | easy | 1 `pod` |
| [ssh-hardening](ssh-hardening) | Linux hardening | easy | 1 `vm` |
| [sudoers-cleanup](sudoers-cleanup) | Linux hardening | medium | 1 `vm` |
| [sysctl-hardening](sysctl-hardening) | Linux hardening | easy | 1 `vm` |
| [auditd-watch](auditd-watch) | Linux hardening | medium | 1 `vm` (own image) |
| [firewall-nftables](firewall-nftables) | Linux hardening | medium | 1 `vm` |

## Layout

Every directory holding a `challenge.yaml` is one challenge package, with its own version (`metadata.version`), released and installed independently:

```
<challenge>/
  challenge.yaml          manifest: machines, access, tasks and their checks
  instructions/en.md      what the student reads
  images/<machine>/       Dockerfile (pod machines) or image.yaml VM image recipe (vm machines)
  setup/                  scripts run once when an instance starts
  solution/               reference solution (teachers and tests only)
```

To add a challenge, copy [brokelabs-challenge-template](https://github.com/Sigeth/brokelabs-challenge-template) into a new directory. Its README is the author guide. Machine images follow the same rules here: start from a [brokelabs-images](https://github.com/Sigeth/brokelabs-images) container base (the `student` user and group, 1000:1000), and add only the tools the tasks need.

## Development

```sh
brokelabs challenge lint leaky-home
brokelabs challenge images leaky-home                       # images built from images/<machine>/
brokelabs challenge manifest leaky-home | kubectl apply -f -   # install on a dev platform (unsigned)
```

CI lints every challenge. In the BrokeLabs workspace, `make dev-challenges` (or Tilt) builds the images and installs every challenge on the dev cluster, and `make test-challenges` runs `brokelabs challenge test` on all of them.

## Releasing

Bump `metadata.version` in the challenge's `challenge.yaml`, then push a tag `<challenge>/v<version>`:

```sh
git tag -a ssh-hardening/v0.1.0 -m ssh-hardening/v0.1.0 && git push origin ssh-hardening/v0.1.0
```

The release workflow tests the challenge on a fresh cluster (every task fails, the solution runs, every task passes), then publishes its machine images, the package (`ghcr.io/sigeth/brokelabs-challenges/<challenge>`) and the official catalog index (`ghcr.io/sigeth/brokelabs-catalog:latest`), all signed keyless by the workflow. Installs trust that identity through the chart's `official` catalog source.

## License

[MIT](LICENSE)
