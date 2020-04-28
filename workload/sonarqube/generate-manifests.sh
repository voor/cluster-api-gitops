#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add oteemocharts https://oteemo.github.io/charts
helm repo update

helm template sonarqube-db bitnami/postgresql -f postgresql-values.yaml --create-namespace -n sonarqube > sonarqube.yaml
helm template sonarqube oteemocharts/sonarqube -f sonarqube-values.yaml -n sonarqube >> sonarqube.yaml