#!/usr/bin/env bash
set -eux

secret_files="${1:-secrets/*.yaml}"

for secret in $secret_files
do
    nopath=${secret:8}
    sealed=${nopath%.yaml}
    output=${sealed%-config}
    kubectl create -f ${secret} --dry-run=client -o json | kubeseal --cert workload-secrets.pem -o yaml > ${output}/manifests/${sealed}-sealed.yaml
done
