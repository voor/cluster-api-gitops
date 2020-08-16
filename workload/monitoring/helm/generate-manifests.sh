#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm template monitoring bitnami/prometheus-operator -f monitoring/helm/monitoring-values.yaml | ytt --ignore-unknown-comments -f- -f monitoring/helm/overlay-helmtemplate.yaml > monitoring/manifests/prometheus-operator.yaml
helm template grafana bitnami/grafana -f monitoring/helm/grafana-values.yaml | ytt --ignore-unknown-comments -f- -f monitoring/helm/grafana-overlay-helmtemplate.yaml > monitoring/manifests/grafana.yaml