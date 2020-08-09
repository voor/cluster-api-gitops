#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm template metrics-server bitnami/metrics-server -f monitoring/helm/metrics-server-values.yaml --namespace monitoring | ytt --ignore-unknown-comments -f- -f monitoring/helm/overlay-helmtemplate.yaml > monitoring/manifests/metrics-server.yaml