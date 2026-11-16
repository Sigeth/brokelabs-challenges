# Image of the "web" machine: busybox provides the shell, netstat, ps, kill and
# wget, busybox-extras the httpd the challenge needs. No sudo, no package
# manager. The opslab base brings the student user (1000:1000) and its home,
# and runs as that user.
FROM ghcr.io/sigeth/opslab-images/alpine-3.24:1.0.0@sha256:b5813ffd71c722ba0cab3e5ad68b68668f2f4c137f617e01ad1ac91816a8399e
# Install as root, then drop the package manager: nothing is installed at run time.
USER root
RUN apk add --no-cache busybox-extras && drop-package-manager
USER 1000:1000
