variable "cluster_id" {
  type        = string
  description = "The name of your HCP Consul cluster"
  default     = "hcp-demo"
}

variable "vpc_region" {
  type        = string
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

variable "hvn_region" {
  type        = string
  description = "The HCP region to create resources in"
  default     = "us-west-2"
}

variable "hvn_id" {
  type        = string
  description = "The name of your HCP HVN"
  default     = "hcp-demo"
}

variable "hvn_cidr_block" {
  type        = string
  description = "The CIDR range to create the HCP HVN with"
  default     = "172.25.32.0/20"
}

variable "consul_tier" {
  type        = string
  description = "The HCP Consul tier to use when creating a Consul cluster"
  default     = "development"
}

variable "vault_tier" {
  type        = string
  description = "The HCP Vault tier to use when creating a Vault cluster"
  default     = "dev"
}

variable "hcp_client_id" {
  description = "HCP Client ID."
  type        = string
  sensitive   = true
}

variable "hcp_client_secret" {
  description = "HCP Client Secret."
  type        = string
  sensitive   = true
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