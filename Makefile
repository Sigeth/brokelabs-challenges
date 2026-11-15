# Release pipeline of one challenge (D44), run by .github/workflows/release.yaml
# on a GitHub runner when a tag <challenge>/v<version> is pushed. The steps
# are in scripts/release.sh.
#
#   make release-check TAG=ssh-hardening/v0.1.0
#   make test-cluster                       k3s, KubeVirt and opslab (sudo: CI runners only)
#   make release-test CHALLENGE=ssh-hardening
#   make release-publish CHALLENGE=ssh-hardening

.PHONY: release-check test-cluster release-test release-publish

release-check:
	scripts/release.sh check $(TAG)

test-cluster:
	scripts/release.sh cluster

## release-test: build the machine images, import them into k3s and run opslab challenge test
release-test:
	scripts/release.sh load $(CHALLENGE)
	scripts/release.sh test $(CHALLENGE)

## release-publish: publish the tested images, the signed package and the signed catalog index
release-publish:
	scripts/release.sh publish $(CHALLENGE)
