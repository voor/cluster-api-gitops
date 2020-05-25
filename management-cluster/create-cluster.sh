#!/bin/sh
USAGE="Usage: $0 CLUSTER_NAME (additional tkg create cluster parameters)"

if [ "$#" == "0" ]; then
  echo "$USAGE"
  exit 1
fi

if [ ! -f management-secrets.pem ]; then
  echo "Sealed Secrets Key for Management Cluster Not Found!"
fi


set -eux

CLUSTER_NAME=$1
WORKING=$(mktemp -d -t ${CLUSTER_NAME}XXXXX)
shift

tkg create cluster $CLUSTER_NAME $@ --dry-run | ytt --ignore-unknown-comments --data-value cluster_name=${CLUSTER_NAME} -f template-assist -f- > workload/manifests/${CLUSTER_NAME}.yaml
# tkg create cluster $CLUSTER_NAME $@ --dry-run | ytt --ignore-unknown-comments -f postcreate-assist -f- > ${WORKING}/${CLUSTER_NAME}.yaml
# kubectl create -f ${WORKING}/${CLUSTER_NAME}.yaml --dry-run=client -o json | kubeseal --cert management-secrets.pem -o yaml > workload/manifests/${CLUSTER_NAME}-postcreate.sealed.yaml \
#   || rm -rf $WORKING
# rm -rf $WORKING