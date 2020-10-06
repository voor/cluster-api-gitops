#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm template monitoring bitnami/kube-prometheus -f monitoring/helm/monitoring-values.yaml --include-crds | ytt --ignore-unknown-comments -f- -f monitoring/helm/overlay-helmtemplate.yaml > monitoring/manifests/prometheus-operator.yaml
helm template grafana bitnami/grafana -f monitoring/helm/grafana-values.yaml --include-crds | ytt --ignore-unknown-comments -f- -f monitoring/helm/grafana-overlay-helmtemplate.yaml > monitoring/manifests/grafana.yaml