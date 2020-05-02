#!/usr/bin/env bash
set -eux

for secret in secrets/*.yaml
do
    nopath=${secret:8}
    sealed=${nopath%.yaml}
    output=${sealed%-config}
    kubectl create -f ${secret} --dry-run=client -o json | kubeseal --cert workload-secrets.pem -o yaml > ${output}/${sealed}-sealed.yaml
done
