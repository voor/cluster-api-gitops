#!/bin/sh

set -eux

echo "Populates the management cluster with necessary apps."

for app in sealed-secrets kapp-controller workload-clusters; do
    ytt --ignore-unknown-comments -f deploy/${app} | kapp -y deploy -n kube-system -a ${app} -f -
done