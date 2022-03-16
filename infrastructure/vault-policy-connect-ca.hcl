path "/sys/mounts" {
  capabilities = [ "read" ]
}

path "/sys/mounts/connect_root" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/sys/mounts/connect_inter" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/connect_root/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

path "/connect_inter/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

