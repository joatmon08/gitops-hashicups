terraform {
  required_version = "~> 1.0"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.22"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.4.1"
    }
  }
}

provider "vault" {
  address   = local.vault_addr
  token     = local.vault_token
  namespace = local.vault_namespace
}

provider "aws" {
  region     = local.region
}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = local.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}