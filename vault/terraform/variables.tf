variable "tfc_organization" {
  type        = string
  description = "TFC Organization for remote state of infrastructure"
}

data "terraform_remote_state" "infrastructure" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = "infrastructure"
    }
  }
}

data "terraform_remote_state" "database" {
  backend = "remote"

  config = {
    organization = var.tfc_organization
    workspaces = {
      name = "database"
    }
  }
}

locals {
  region          = data.terraform_remote_state.infrastructure.outputs.region
  cluster_id      = data.terraform_remote_state.infrastructure.outputs.kubernetes_cluster_id
  vault_addr      = data.terraform_remote_state.infrastructure.outputs.vault_addr
  vault_token     = data.terraform_remote_state.infrastructure.outputs.vault_token
  vault_namespace = data.terraform_remote_state.infrastructure.outputs.vault_namespace

  access_key_id     = data.terraform_remote_state.infrastructure.outputs.vault_access_key_id
  secret_access_key = data.terraform_remote_state.infrastructure.outputs.vault_secret_access_key

  kubernetes_cluster_iam_role_arn = data.terraform_remote_state.infrastructure.outputs.kubernetes_cluster_iam_role_arn
  database_username               = data.terraform_remote_state.database.outputs.database_username
  database_password               = data.terraform_remote_state.database.outputs.database_password
  database_host                   = data.terraform_remote_state.database.outputs.database_host
  database_name                   = data.terraform_remote_state.database.outputs.database_name
  database_port                   = data.terraform_remote_state.database.outputs.database_port
}

variable "application" {
  type        = string
  description = "Name of application for base path"
  default     = "hashicups"
}

variable "service" {
  type        = string
  description = "Name of Kubernetes service for Vault role"
  default     = "product"
}

variable "service_account" {
  type        = string
  description = "Name of Kubernetes service account used for service"
  default     = "product-api"
}

variable "namespace" {
  type        = string
  description = "Name of Kubernetes namespace used for service"
  default     = "default"
}

variable "aws_access_key" {
  description = "AWS Access Key."
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS Secret Key."
  type        = string
  sensitive   = true
}