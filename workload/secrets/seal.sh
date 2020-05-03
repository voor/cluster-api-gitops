#!/usr/bin/env bash
set -eux

secret_files="${1:-secrets/*.yaml}"

for secret in $secret_files
do
    nopath=${secret:8} # Strips off secrets/ folder name
    sealed=${nopath%.yaml} # Removes yaml at the end
    outputfolder=${sealed%.*} # Removes optional numbering
    output=${outputfolder%-config} # Remove config at the end.
    kubectl create -f ${secret} --dry-run=client -o json | kubeseal --cert workload-secrets.pem -o yaml > ${output}/manifests/${sealed}.sealed.yaml
done
