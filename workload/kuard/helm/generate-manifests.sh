#!/usr/bin/env sh
set -eux

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm template kuard-proxy stable/oauth2-proxy -f kuard/helm/oauth2-proxy-values.yaml --namespace kuard | ytt --ignore-unknown-comments -f- -f kuard/helm/overlay-helmtemplate.yaml > kuard/manifests/kuard-proxy.yaml