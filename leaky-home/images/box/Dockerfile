# Image of the "box" machine. Keep machine images minimal: only the tools the
# challenge needs (here bash; ls, chmod, find, sed... come from busybox).
# No sudo, no systemd, no compilers. The opslab base brings the student user
# (1000:1000) and its home, and runs as that user.
FROM ghcr.io/sigeth/opslab-images/alpine-3.24:1.0.0@sha256:b5813ffd71c722ba0cab3e5ad68b68668f2f4c137f617e01ad1ac91816a8399e
# Install as root, then drop the package manager: nothing is installed at run time.
USER root
RUN apk add --no-cache bash && drop-package-manager
USER 1000:1000
CMD ["bash", "-l"]
