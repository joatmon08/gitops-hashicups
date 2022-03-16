terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43"
    }
    consul = {
      source  = "hashicorp/consul"
      version = "~> 2.14"
    }
  }
}

provider "aws" {
  region     = local.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "consul" {
  address = local.consul_addr
  token   = local.consul_token
}
