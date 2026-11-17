# Image of the "web" machine: busybox provides the shell, netstat, ps, kill and
# wget, busybox-extras the httpd the challenge needs. No sudo, no package
# manager. The BrokeLabs base brings the student user (1000:1000) and its home,
# and runs as that user.
FROM ghcr.io/sigeth/brokelabs-images/alpine-3.24:1.0.1@sha256:0bda9e219fda6e893138c802fd05ddf396357371b4563429852ecbc8d4d4f7d6
# Install as root, then drop the package manager: nothing is installed at run time.
USER root
RUN apk add --no-cache busybox-extras && drop-package-manager
USER 1000:1000
