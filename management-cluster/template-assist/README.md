# Kapp Controller Deployment

This folder is not deployed from the regular deployment, but is instead initially populated from the management cluster for the workload cluster.

```
tkg create cluster snake --plan=dev --dry-run | ytt -f template-assist -f- > workload/manifests/snake.yaml
```