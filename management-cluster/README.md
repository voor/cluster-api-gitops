# Management Cluster

After you've applied this `management-cluster.yaml` in your temporary bootstrap cluster, you'll need to initialize it with Cluster API components again:

```
kubectl get secret central-kubeconfig -o jsonpath={.data.value} | base64 -d > ~/.kube/central-kubeconfig.config
# Remove the taint from the master (change to correct node name)
KUBECONFIG=~/.kube/central-kubeconfig.config kubectl taint nodes node-role.kubernetes.io/master:NoSchedule-

# kapp in calico
kapp --kubeconfig ~/.kube/central-kubeconfig.config deploy -a calico -f calico.yaml -c

# Deploy AWS provider
KUBECONFIG=~/.kube/central-kubeconfig.config clusterctl init --core cluster-api:v0.3.0 --bootstrap kubeadm:v0.3.0 --control-plane kubeadm:v0.3.0 --infrastructure aws:v0.5.0

# Note that you are pointing to your bootstrap cluster here
clusterctl move --to-kubeconfig=/home/${USER}/.kube/central-kubeconfig.config

# kapp in workload
kapp --kubeconfig ~/.kube/central-kubeconfig.config deploy -a workload -f workload-cluster.yaml
```