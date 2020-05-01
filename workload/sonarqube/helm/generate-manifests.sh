#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add oteemocharts https://oteemo.github.io/charts
helm repo update

helm template sonarqube-db bitnami/postgresql -f sonarqube/helm/postgresql-values.yaml | ytt --ignore-unknown-comments -f- -f sonarqube/helm/overlay-helmtemplate.yaml > sonarqube/sonarqube-db.yaml
helm template sonarqube oteemocharts/sonarqube -f sonarqube/helm/sonarqube-values.yaml | ytt --ignore-unknown-comments -f- -f sonarqube/helm/overlay-helmtemplate.yaml > sonarqube/sonarqube.yaml