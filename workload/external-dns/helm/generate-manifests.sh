#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm template external-dns bitnami/external-dns -f external-dns/helm/external-dns-values.yaml --namespace external-dns --include-crds | ytt --ignore-unknown-comments -f- -f external-dns/helm/overlay-helmtemplate.yaml > external-dns/manifests/external-dns.yaml