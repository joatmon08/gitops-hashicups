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

locals {
  region                     = data.terraform_remote_state.infrastructure.outputs.region
  consul_addr                = data.terraform_remote_state.infrastructure.outputs.consul_addr
  consul_token               = data.terraform_remote_state.infrastructure.outputs.consul_token
  consul_datacenter          = data.terraform_remote_state.infrastructure.outputs.consul_datacenter
  vpc                        = data.terraform_remote_state.infrastructure.outputs.vpc
  database_subnet_group_name = data.terraform_remote_state.infrastructure.outputs.database_subnet_group_name
}

variable "application" {
  type        = string
  description = "Name of application"
  default     = "hashicups"
}

variable "database_name" {
  type        = string
  description = "Name of the database for application"
  default     = "products"
}

variable "database_username" {
  type        = string
  description = "PostgreSQL database username"
  default     = "postgres"
}

variable "allowed_client_cidr_blocks" {
  type        = list(string)
  description = "List of allowed CIDR blocks to publicly access database"
  default     = []
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