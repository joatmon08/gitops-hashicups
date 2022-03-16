resource "vault_aws_secret_backend" "aws" {
  path       = "terraform/aws"
  access_key = local.access_key_id
  secret_key = local.secret_access_key
}

resource "vault_aws_secret_backend_role" "role" {
  backend         = vault_aws_secret_backend.aws.path
  name            = var.application
  credential_type = "assumed_role"
  role_arns       = [local.kubernetes_cluster_iam_role_arn]
  default_sts_ttl = 21600
  max_sts_ttl     = 43200
}

locals {
  aws_creds_path = "${vault_aws_secret_backend.aws.path}/creds/${var.application}"
}

data "vault_policy_document" "aws" {
  rule {
    path         = local.aws_creds_path
    capabilities = ["read"]
    description  = "read AWS credentials for ${var.application} team"
  }
}

resource "vault_policy" "aws" {
  name   = "terraform"
  policy = data.vault_policy_document.aws.hcl
}