#!/usr/bin/env bash

# This script uses arg $1 (name of *.jsonnet file to use) to generate the manifests/*.yaml files.

set -e
set -x
# only exit with zero if all commands of the pipeline exit successfully
set -o pipefail

rm -rf monitoring/manifests/out
mkdir -p monitoring/manifests/out/setup
# Calling gojsontoyaml is optional, but we would like to generate yaml, not json
jsonnet -J monitoring/jsonnet/vendor -m monitoring/manifests/out "${1-monitoring/jsonnet/prometheus-operator.jsonnet}" | xargs -I{} sh -c 'cat {} | ytt -f monitoring/jsonnet/crd-overlay.yaml -f foo.yaml=- > {}.yaml' -- {}

# Make sure to remove json files
find monitoring/manifests/out -type f ! -name '*.yaml' -delete
kubectl create -f monitoring/manifests/out/grafana-config.yaml --dry-run=client -o json | kubeseal --cert workload-secrets.pem -o yaml > monitoring/manifests/grafana-config.sealed.yaml
rm -f monitoring/manifests/out/grafana-config.yaml