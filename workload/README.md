# Workload Cluster

Once you have your cluster up, go ahead and grab the KUBECONFIG and add it to your primary config:

```
kubectl get secrets workload-kubeconfig -o jsonpath={.data.value} | base64 -d > ~/.kube/config.workload \
    && KUBECONFIG=~/.kube/config.workload:~/.kube/config kubectl config view --flatten > ~/.kube/config.new \
    && mv ~/.kube/config.new ~/.kube/config
```
Or with TKG:
```
tkg get credentials $CLUSTER_NAME
```

Now add some stuff!

## Prerequisites

This installation will assume you have two things setup out of band:

* This guide assumes AWS Govcloud, but should work just as easily in AWS Commercial, the reason for Govcloud is just to show cross-AWS region compliance (something often neglected).
* You own a domain name, in this example we're using `tanzu.world` but it can be anything you want (seriously domains cost about $3 or less nowadays).
* You are using [Cloudflare](https://www.cloudflare.com/) to manage the DNS.  Even if you use someone else to register the domain name, you can change the nameservers to point to Cloudflare for free.  Cloudflare has the easiest to consume API, even when compared to AWS Route 53 (also AWS Route 53 isn't available in govcloud regions for public domains).
* You have an API **TOKEN** that has Zone.Zone `Read` and Zone.DNS `Edit` privileges, due to a bug in how Let's Encrypt works you'll also need Account.Account Settings `Read`.

## Initial Installs

These are generic installs that don't have specific configuration required before they're installed.

```
# Calico is the CNI for the workload cluster
# Skip this if using TKG as the CNI is already done for you
kapp -y deploy -a calico -f calico -c
# cert-manager helps with issuing certs internally
kapp -y deploy -a cert-manager -f cert-manager -c
# If you are recovering from another cluster, apply your master.key here:
# kubectl apply -f master.key
# Sealed Secrets is how you securely add secrets into the cluster that can still be stored in a git repository
kapp -y deploy -a sealed-secrets -f sealed-secrets -c
```

## Adding Secrets

Next we need to "seal" the secrets so they're safe to store in git.  This is specific configuration for our clusters.

```
# This is a PUBLIC cert so it's safe to commit!  We grab the public cert so we don't need connectivity to the cluster for generating secrets.
kubeseal --fetch-cert > workload-secrets.pem 
# First edit secrets/cert-manager-config.yaml to contain your secret
kubectl create -f secrets/cert-manager-config.yaml --dry-run -o json | kubeseal --cert workload-secrets.pem -o yaml > secrets/cert-manager-config-sealed.yaml
# First edit the file
kubectl create -f secrets/external-dns-config.yaml --dry-run -o json | kubeseal --cert workload-secrets.pem -o yaml > secrets/external-dns-config-sealed.yaml

# Now we can apply the safely sealed secrets
kubectl create ns external-dns
kapp -y deploy -a external-dns-config -f secrets/external-dns-config-sealed.yaml
kapp -y deploy -a cert-manager-config -f secrets/cert-manager-config-sealed.yaml
```

### Backup Secrets

```
# DO NOT COMMIT THIS IS A PRIVATE KEY
kubectl get secret -n kube-system -l sealedsecrets.bitnami.com/sealed-secrets-key -o yaml >master.key
```


## Post-Secrets Installs

Now that the secrets are properly populated, we can install tooling that was dependent on them:

```
kapp -y deploy -a external-dns -f external-dns -c
```

## Adding Unique Config

These are the files you'll need to edit for your cluster's variables.  Edit the values in these files accordingly.

* `workload/knative/overlays/dev/domain.yaml` 
* `workload/unique/letsencrypt-issuer.yaml`

Install everything after modifying those files:

```
kapp -y deploy -a letsencrypt-issuer -f unique/letsencrypt-issuer.yaml
kustomize build knative/overlays/dev | kapp -y deploy -a knative-serving -f -

```

## Install Apps

Now you just go ahead and build your apps.

```
kapp deploy -a sample-app -f apps/sample.yaml
```