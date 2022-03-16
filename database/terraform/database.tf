resource "aws_security_group" "database" {
  name        = "${var.application}-database"
  description = "Allow inbound traffic to database"
  vpc_id      = local.vpc.vpc_id

  ingress {
    description = "Allow inbound from VPC, HCP, and local machine"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    ## Further debugging required for public interface access from HCP Vault to database
    # cidr_blocks = concat([local.vpc.vpc_cidr_block, local.vpc.hvn_cidr_block], var.allowed_client_cidr_blocks)

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "postgres" {
  length           = 12
  special          = true
  override_special = "!-"
}

resource "aws_db_instance" "products" {
  allocated_storage      = 10
  engine                 = "postgres"
  engine_version         = "11.12"
  instance_class         = "db.t3.micro"
  name                   = var.database_name
  identifier             = "${var.application}-${var.database_name}"
  username               = var.database_username
  password               = random_password.postgres.result
  db_subnet_group_name   = local.database_subnet_group_name
  vpc_security_group_ids = [aws_security_group.database.id]
  skip_final_snapshot    = true
  publicly_accessible    = true
}