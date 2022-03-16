data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_iam_role" "cluster" {
  name                 = "${var.cluster_id}-eks"
  max_session_duration = 21600

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${aws_iam_user.vault.arn}"
        }
      },
    ]
  })

  inline_policy {
    name = "kubernetes"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action   = ["eks:*"]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
    })
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.22.0"

  cluster_name    = "${var.cluster_id}-eks"
  cluster_version = "1.21"
  subnets         = module.vpc.public_subnets
  vpc_id          = module.vpc.vpc_id
  map_roles = [
    {
      rolearn  = aws_iam_role.cluster.arn
      username = "admin"
      groups   = ["system:masters"]
    },
  ]

  node_groups = {
    nodes = {
      name_prefix      = "hcp-demo"
      instance_types   = ["m5.large"]
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3
    }
  }
}