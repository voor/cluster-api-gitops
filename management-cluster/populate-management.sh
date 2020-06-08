#!/bin/sh

set -eux

echo "Populates the management cluster with necessary apps."

# If we have an existing secret apply it first.
if [ -f "master.key" ]; then
    kubectl apply -f master.key
fi

for app in sealed-secrets kapp-controller workload-clusters workload-secrets gangway; do
    ytt --ignore-unknown-comments -f deploy/${app}/manifests | kapp -y deploy -n kube-system -a ${app} -f -
done