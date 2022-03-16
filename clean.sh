#!/bin/bash

export CONSUL_HTTP_ADDR=$(cd database/terraform/ && terraform output -raw consul_addr)
export CONSUL_HTTP_TOKEN=$(cd database/terraform/ && terraform output -raw consul_token)

export VAULT_ADDR=$(cd vault/terraform && terraform output -raw vault_addr)
export VAULT_NAMESPACE=$(cd vault/terraform && terraform output -raw vault_namespace)
export VAULT_TOKEN=$(cd vault/terraform && terraform output -raw vault_token)

flux suspend kustomization hashicups -n flux-system
flux delete kustomization hashicups -n flux-system

flux suspend source git hashicups -n flux-system
flux delete source git hashicups -n flux-system

kubectl delete -f clusters/eks/hashicups-kustomization.yaml
kubectl delete -f clusters/eks/hashicups-source.yaml

flux uninstall

vault lease revoke -f -prefix hashicups/database/creds/product
vault lease revoke -f -prefix terraform/aws/creds/hashicups

kubectl patch gatewayclasses.gateway.networking.k8s.io consul-api-gateway --type merge --patch '{"metadata":{"finalizers":[]}}'
kubectl patch gatewayclassconfigs.api-gateway.consul.hashicorp.com consul-api-gateway --type merge --patch '{"metadata":{"finalizers":[]}}'