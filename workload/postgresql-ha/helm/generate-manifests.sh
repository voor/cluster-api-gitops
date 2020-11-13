#!/usr/bin/env sh
set -eux

echo "#! DO NOT MODIFY THIS FILE DIRECTLY IT IS GENERATED FROM $0" > postgresql-ha/manifests/postgresql.yaml
helm template postgresql-ha /home/voor/workspace/bitnami-charts/bitnami/postgresql-ha -f postgresql-ha/helm/postgresql-ha-values.yaml --namespace replaced --include-crds >> postgresql-ha/manifests/postgresql.yaml