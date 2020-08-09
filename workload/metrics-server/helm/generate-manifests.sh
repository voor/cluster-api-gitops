#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm template metrics-server bitnami/metrics-server -f metrics-server/helm/metrics-server-values.yaml --namespace kube-system | ytt --ignore-unknown-comments -f- -f metrics-server/helm/overlay-helmtemplate.yaml > metrics-server/manifests/metrics-server.yaml