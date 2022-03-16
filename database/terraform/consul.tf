resource "consul_service" "database" {
  name = "postgres"
  node = consul_node.database.name
  port = 5432
  tags = ["external"]
  meta = {}

  check {
    check_id = "service:postgres"
    name     = "Postgres health check"
    status   = "passing"
    tcp      = "${aws_db_instance.products.address}:5432"
    interval = "30s"
    timeout  = "3s"
  }
}

resource "consul_node" "database" {
  name    = "postgres"
  address = aws_db_instance.products.address

  meta = {
    "external-node"  = "true"
    "external-probe" = "true"
  }
}

resource "consul_config_entry" "database" {
  name = "postgres"
  kind = "service-defaults"

  config_json = jsonencode({
    TransparentProxy = {}
    Protocol         = "tcp"
    Expose           = {}
    MeshGateway      = {}
  })
}

resource "consul_acl_policy" "database" {
  name        = "database-write-policy"
  datacenters = [local.consul_datacenter]

  rules = <<-RULE
    service "postgres" {
        policy = "write"
    }
  RULE
}