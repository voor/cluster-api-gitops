#!/usr/bin/env sh
set -eux

helm repo add uswitch https://uswitch.github.io/kiam-helm-charts/charts/
helm repo update

helm template kiam uswitch/kiam -f kiam/helm/kiam-values.yaml --namespace kube-system | ytt --ignore-unknown-comments -f- -f kiam/helm/overlay-helmtemplate.yaml > kiam/manifests/kiam.yaml