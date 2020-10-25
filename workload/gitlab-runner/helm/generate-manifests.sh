#!/usr/bin/env sh
set -eux

helm repo add gitlab https://charts.gitlab.io
helm repo update

helm template s gitlab/gitlab-runner -f gitlab-runner/helm/gitlab-runner-values.yaml --namespace gitlab-runner | ytt --ignore-unknown-comments -f- -f gitlab-runner/helm/overlay-helmtemplate.yaml > gitlab-runner/manifests/gitlab-runner.yaml