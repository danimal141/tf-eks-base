# tf-eks-base

## Dependencies
- kubectl
- AWS command
- Terraform (`v0.13.*`)

## Creating EKS base

```bash
// Initialize working dir
$ terraform init

// dry-run
$ terraform plan

// Create or change resources
$ terraform apply -var 'key_name=YOUR KEY NAME'

// Delete resources
$ terraform destroy
```

## To recognize nodes

```bash
$ mkdir -p .kube
$ mkdir -p manifests

$ terraform output kubectl_config > .kube/config
$ terraform output eks_configmap > ./manifests/config_map.yml

$ export KUBECONFIG='.kube/config'
$ kubectl apply -f manifests/config_map.yml

// Check
$ kubectl get nodes
```
