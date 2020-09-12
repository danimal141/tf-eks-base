# tf-eks-base

## Dependencies
- AWS command (`v1.18.*`)
- kubectl (`v1.17.*`)
- Terraform (`v0.13.*`)

## Create EKS base

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

## Recognize nodes

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
