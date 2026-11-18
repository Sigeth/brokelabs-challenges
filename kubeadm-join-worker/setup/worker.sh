#!/bin/sh
# The worker only gets its images imported: joining it is the challenge.
set -eu
systemctl start brokelabs-k8s-images
