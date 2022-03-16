output "consul_addr" {
  value = local.consul_addr
}

output "consul_token" {
  value     = local.consul_token
  sensitive = true
}

output "database_username" {
  value = aws_db_instance.products.username
}

output "database_password" {
  value     = aws_db_instance.products.password
  sensitive = true
}

output "database_host" {
  value = aws_db_instance.products.address
}

output "database_port" {
  value = aws_db_instance.products.port
}

output "database_name" {
  value = aws_db_instance.products.name
}
