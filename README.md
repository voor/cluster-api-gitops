# Tanzu Kubernetes Grid GitOps Flow Sample

**Last Run Against TKG 1.1**

This is a sample showing the power of Cluster API and Tanzu Kubernetes Grid in a GitOps work model.

You start with the Management Cluster, do a typical install of TKG following the directions [here](https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.1/vmware-tanzu-kubernetes-grid-11/GUID-index.html)

1. Fork this repository, rename references in the code pointing to https://github.com/voor/cluster-api-gitops to your fork.  Push those changes.
1. Go into `management-cluster/deploy/workload-secrets` and change the example file accordingly.  
    1. This assumes you are using [CloudFlare](https://www.cloudflare.com/) to manage your domain specified in the domain secret, if you are not you'll need to change the [`letsencrypt`](workload/letsencrypt/manifests/letsencrypt-issuer.yaml) and [`external-dns`](workload/external-dns/manifests/external-dns.yaml) programs in the workload folder accordingly.
    1. You have a GitHub OAuth2.0 application setup, or you'll need to change [`dex-config.yaml`](workload/dex/manifests/dex-config.yaml#L35-L47) to point elsewhere.
1. Populate the management cluster, go into the `management-cluster` folder and run:
    ```
    ./populate-management.sh
    ```
1. Create your first workload cluster:
    ```
    ./create-cluster.sh hello-world -c 1 -p dev -w 1
    ```
1. Commit the `${CLUSTER_NAME}`.yaml file that was added into `workload/manifests` into git and push it.
1. Wait a few minutes.
1. Visit the URL `https://kuard.apps.${DOMAIN}` where `${DOMAIN}` is the url you specified in the `workload-secrets` yaml.

## Scaling Clusters

### Workers
Go into the yaml for the workload cluster and change the number of `MachineDeployment` replicas.

### Masters
Go into the yaml for the workload cluster and change the number of `KubeadmControlPlane` replicas.

## Upgrading Clusters

TODO

## Changing Workloads

Everything for workload clusters is found in the `workload` folder in this repository, this sample takes a few commonly used applications that are both Helm, Jsonnet, and pure manifest based.

### Helm

Helm applications are committed directly as manifests to remove any surprises and make this more air-gapped friendly.  [kapp-controller](https://github.com/k14s/kapp-controller) supports helm charts directly, so see there for more documentation on how to modify this to pull directly from a helm repository.

### Pure Manifests

Everything is run through `ytt`, so even if you are checking out manifests directly from a release (and if you are, you can always just fetch over URL), you can apply overlays or other modifications without committing them directly to the release files.