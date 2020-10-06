#!/bin/sh
USAGE="Usage: $0 CLUSTER_NAME (additional tkg create cluster parameters)"

if [ "$#" == "0" ]; then
  echo "$USAGE"
  exit 1
fi

set -eux

CLUSTER_NAME=$1

shift

export AWS_NODE_AZ=unused
export AWS_PRIVATE_NODE_CIDR=unused
export AWS_PUBLIC_NODE_CIDR=unused
export AWS_REGION=us-gov-west-1
export AWS_SSH_KEY_NAME=overridden
unset AWS_AMI_ID
export AWS_VPC_ID=overriden
export CONTROL_PLANE_MACHINE_TYPE=m5n.large
export NODE_MACHINE_TYPE=m5n.large

tkg create cluster -i aws $CLUSTER_NAME $@ --dry-run 2>/dev/null | ytt --ignore-unknown-comments --data-value cluster_name=${CLUSTER_NAME} -f template-assist -f- > workload/manifests/clusters/${CLUSTER_NAME}.yaml