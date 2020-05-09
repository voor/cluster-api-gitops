# Single Node YTT Overlay

Have a single k8s node, and need your deployments to get scheduled on the master?  Don't want to remove the taint so you have better control over what happens?  Worry no more!  With this simple `ytt` overlay to add the toleration to every deployment.

```shell
kubectl get deployment -n cert-manager -o yaml | ytt -f single-node -f - | kubectl apply -f -
```