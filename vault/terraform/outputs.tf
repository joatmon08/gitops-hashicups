output "vault_addr" {
  value = local.vault_addr
}

output "vault_token" {
  value     = local.vault_token
  sensitive = true
}

output "vault_namespace" {
  value = local.vault_namespace
}

output "database_creds_path" {
  value = local.database_creds_path
}