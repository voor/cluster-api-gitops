#!/usr/bin/env sh
set -eux

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add oteemocharts https://oteemo.github.io/charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update

helm template sonarqube-proxy stable/oauth2-proxy -f sonarqube/helm/oauth2-proxy-values.yaml --namespace sonar | ytt --ignore-unknown-comments -f- -f sonarqube/helm/overlay-helmtemplate.yaml > sonarqube/manifests/sonarqube-proxy.yaml
helm template sonarqube-db bitnami/postgresql -f sonarqube/helm/postgresql-values.yaml --namespace sonar | ytt --ignore-unknown-comments -f- -f sonarqube/helm/overlay-helmtemplate.yaml > sonarqube/manifests/sonarqube-db.yaml
helm template sonarqube oteemocharts/sonarqube -f sonarqube/helm/sonarqube-values.yaml --namespace sonar | ytt --ignore-unknown-comments -f- -f sonarqube/helm/overlay-helmtemplate.yaml > sonarqube/manifests/sonarqube.yaml