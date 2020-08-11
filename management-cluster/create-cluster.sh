#!/bin/sh
USAGE="Usage: $0 CLUSTER_NAME (additional tkg create cluster parameters)"

if [ "$#" == "0" ]; then
  echo "$USAGE"
  exit 1
fi

set -eux

CLUSTER_NAME=$1

shift

tkg create cluster -i aws $CLUSTER_NAME $@ --dry-run 2>/dev/null | ytt --ignore-unknown-comments --data-value cluster_name=${CLUSTER_NAME} -f template-assist -f- > workload/manifests/${CLUSTER_NAME}.yaml