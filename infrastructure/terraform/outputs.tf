output "vault_addr" {
  value = hcp_vault_cluster.main.vault_public_endpoint_url
}

output "vault_token" {
  value     = hcp_vault_cluster_admin_token.main.token
  sensitive = true
}

output "vault_namespace" {
  value = hcp_vault_cluster.main.namespace
}

output "private_vault_addr" {
  value = hcp_vault_cluster.main.vault_private_endpoint_url
}

output "consul_addr" {
  value = hcp_consul_cluster.main.consul_public_endpoint_url
}

output "consul_datacenter" {
  value = hcp_consul_cluster.main.datacenter
}

output "consul_token" {
  value     = hcp_consul_cluster_root_token.token.secret_id
  sensitive = true
}

output "kubernetes_cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "region" {
  value = var.vpc_region
}

output "kubernetes_cluster_id" {
  value = module.eks.cluster_id
}

output "vpc" {
  value = {
    vpc_id         = module.vpc.vpc_id
    vpc_cidr_block = module.vpc.vpc_cidr_block
    hvn_cidr_block = var.hvn_cidr_block
  }
}

output "database_subnet_group_name" {
  value = module.vpc.database_subnet_group_name
}

output "kubernetes_cluster_iam_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "vault_access_key_id" {
  value     = aws_iam_access_key.vault.id
  sensitive = true
}

output "vault_secret_access_key" {
  value     = aws_iam_access_key.vault.secret
  sensitive = true
}