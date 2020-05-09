#!/bin/sh

set -eux

echo "Populates the management cluster with necessary apps."

for app in sealed-secrets kapp-controller workload-clusters; do
    ytt --ignore-unknown-comments -f deploy/${app} -f deploy/values.yaml | kapp -y deploy -a ${app} -f -
done