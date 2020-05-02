#!/usr/bin/env sh
set -eux

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm template dex stable/dex -f dex/helm/dex-values.yaml | ytt --ignore-unknown-comments -f- -f dex/helm/overlay-helmtemplate.yaml > dex/dex.yaml