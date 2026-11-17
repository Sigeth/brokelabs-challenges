# exposed debug port

A beginner **containers** challenge for [BrokeLabs](https://github.com/Sigeth): a web container leaks a database dump and runs a forgotten debug server. The student closes both leaks while keeping the site up.

- Runtime: one `pod` machine built from `images/web` (Alpine base with busybox and busybox-extras' httpd, unprivileged user `student`)
- Checks: `port` and `http`, probed from the network (black-box)
- Solution: `solution/solve.sh` (for teachers and `brokelabs challenge test`)

```sh
brokelabs challenge lint exposed-debug-port
brokelabs challenge manifest exposed-debug-port | kubectl apply -f -   # install on a dev platform
```

## License

[MIT](../LICENSE)
