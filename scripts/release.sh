#!/usr/bin/env bash
# Release pipeline of one challenge (D44), run by .github/workflows/release.yaml
# on a GitHub runner, through the Makefile:
#
#   scripts/release.sh check TAG          the tag <challenge>/v<version> matches challenge.yaml
#   scripts/release.sh cluster            k3s, KubeVirt and the platform on this machine (sudo)
#   scripts/release.sh load CHALLENGE     build its machine images and import them into k3s
#   scripts/release.sh test CHALLENGE     opslab challenge test (fail, solution, pass)
#   scripts/release.sh publish CHALLENGE  images (the tested bytes), signed package, signed index
#
# Machine images are built once (Dagger), tested from the local k3s, then
# published from the same archives, so what is published is what was tested.
# Signatures are keyless: the OIDC identity of this workflow (D40), which the
# official catalog source of the chart trusts.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${OPSLAB:=opslab}"
: "${DAGGER:=dagger}"
: "${CI_MODULE:=github.com/Sigeth/opslab-ci@v0.3.1}"
: "${K3S_VERSION:=v1.37.2+k3s1}"
: "${CHART:=../opslab-charts/opslab}"
REGISTRY=ghcr.io/sigeth/opslab-challenges
CATALOG=ghcr.io/sigeth/opslab-catalog:latest
BUILD=.release
images=/var/lib/rancher/k3s/agent/images

# version_of prints the package version, as lint reads it ("<name> <version>: valid").
version_of() { "$OPSLAB" challenge lint "$1" | awk 'NR == 1 { sub(":", "", $2); print $2 }'; }

check() {
  local tag=$1 challenge=${1%%/*} version=${1#*/v}
  [[ -f "$challenge/challenge.yaml" ]] || { echo "no challenge $challenge" >&2; exit 1; }
  [[ "$(version_of "$challenge")" == "$version" ]] || {
    echo "$challenge/challenge.yaml is at version $(version_of "$challenge"), not $version" >&2
    exit 1
  }
  "$OPSLAB" challenge lint "$challenge"
  # The package may only use images this repository publishes, or public bases.
  while IFS=$'\t' read -r machine ref dir; do
    [[ "$dir" == "-" || "$ref" == "$REGISTRY/$challenge/$machine:"* ]] || {
      echo "$machine: $ref must be $REGISTRY/$challenge/$machine:<version>" >&2
      exit 1
    }
  done < <("$OPSLAB" challenge images "$challenge")
  echo "$tag: releasing $challenge $version"
}

cluster() {
  # GitHub runners expose /dev/kvm to root only.
  echo 'KERNEL=="kvm", GROUP="kvm", MODE="0666", OPTIONS+="static_node=kvm"' |
    sudo tee /etc/udev/rules.d/99-kvm.rules >/dev/null
  sudo udevadm control --reload-rules && sudo udevadm trigger --name-match=kvm
  sudo install -d /etc/rancher/k3s
  printf 'disable: [traefik, servicelb]\nwrite-kubeconfig-mode: "0644"\nnode-label: ["opslab.io/kvm=true"]\n' |
    sudo tee /etc/rancher/k3s/config.yaml >/dev/null
  curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="$K3S_VERSION" sh -
  mkdir -p ~/.kube && sudo cat /etc/rancher/k3s/k3s.yaml >~/.kube/config
  kubectl wait --for=condition=Ready node --all --timeout=180s
  # KubeVirt first: the operator detects it when it starts (D35).
  "$OPSLAB" addon kubevirt install
  # Only what tests need: no mirror, no official catalog (being released).
  helm install opslab "$CHART" --namespace opslab-system --create-namespace --wait --timeout 10m \
    --set mirror.enabled=false --set catalogs.official.enabled=false
}

# images lists the machine images built from the challenge: machine, ref, dir.
images() { "$OPSLAB" challenge images "$1" | awk -F'\t' '$3 != "-"'; }

# archive builds a machine image into $BUILD/<machine>.tar, an OCI archive
# named after its ref (the annotation containerd imports it under).
archive() {
  local machine=$1 ref=$2 dir=$3 kind=image
  [[ -f "$dir/image.yaml" ]] && kind=vm-image
  mkdir -p "$BUILD/$machine"
  "$DAGGER" call -m "$CI_MODULE" "$kind" --source="$dir" export --path="$BUILD/$machine.oci.tar" >/dev/null
  tar -xf "$BUILD/$machine.oci.tar" -C "$BUILD/$machine"
  jq --arg ref "$ref" '.manifests[0].annotations["org.opencontainers.image.ref.name"] = $ref' \
    "$BUILD/$machine/index.json" >"$BUILD/$machine/index.json.new"
  mv "$BUILD/$machine/index.json.new" "$BUILD/$machine/index.json"
  (cd "$BUILD/$machine" && tar -cf ../"$machine".tar oci-layout index.json blobs)
  rm -rf "${BUILD:?}/$machine" "$BUILD/$machine.oci.tar"
}

load() {
  local challenge=$1
  rm -rf "$BUILD" && mkdir -p "$BUILD"
  while IFS=$'\t' read -r machine ref dir; do
    echo "building $ref"
    archive "$machine" "$ref" "$dir"
    sudo k3s ctr -n k8s.io images import "$BUILD/$machine.tar" >/dev/null
  done < <(images "$challenge")
}

run_test() { "$OPSLAB" challenge test "$1"; }

publish() {
  local challenge=$1 version
  version=$(version_of "$challenge")
  : "${REGISTRY_TOKEN:?the token pushing to ghcr.io}" "${REGISTRY_USER:?its user}"
  echo "$REGISTRY_TOKEN" | docker login ghcr.io -u "$REGISTRY_USER" --password-stdin >/dev/null
  while IFS=$'\t' read -r machine ref dir; do
    echo "publishing $ref"
    skopeo copy --quiet --preserve-digests --dest-creds "$REGISTRY_USER:$REGISTRY_TOKEN" \
      "oci-archive:$BUILD/$machine.tar" "docker://$ref"
  done < <(images "$challenge")
  # build pins every image by digest: the ones just published, and the bases.
  "$OPSLAB" challenge build "$challenge" -o "$BUILD/package"
  local pkg index
  pkg=$("$OPSLAB" challenge push "$BUILD/package" "$REGISTRY/$challenge")
  "$OPSLAB" challenge sign "$pkg" --keyless
  index=$("$OPSLAB" catalog index --base "$CATALOG" --create-if-missing --push "$CATALOG" "$pkg" | cut -d' ' -f1)
  "$OPSLAB" catalog sign "$index" --keyless
  echo "$challenge $version: $pkg, listed in $index"
}

case "${1:-}" in
  check | load | publish) "$1" "${2:?missing argument}" ;;
  test) run_test "${2:?missing argument}" ;;
  cluster) cluster ;;
  *) echo "usage: $0 check TAG | cluster | load|test|publish CHALLENGE" >&2; exit 1 ;;
esac
