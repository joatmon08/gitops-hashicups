#!/bin/bash

export CONSUL_HTTP_ADDR=$(cd terraform/ && terraform output -raw consul_addr)
export CONSUL_HTTP_TOKEN=$(cd terraform/ && terraform output -raw consul_token)

export VAULT_ADDR=$(cd terraform/ && terraform output -raw vault_addr)
export VAULT_NAMESPACE=$(cd terraform/ && terraform output -raw vault_namespace)
## you will need to run terraform taint and re-apply when this expires
export VAULT_TOKEN=$(cd terraform/ && terraform output -raw vault_token)

# Create Vault policy
vault policy write connect-ca vault-policy-connect-ca.hcl

# create Vault token
vault token create -policy=connect-ca -format=json > vault_token.json

export PRIVATE_VAULT_ADDR=$(cd terraform/ && terraform output -raw private_vault_addr)
export PRIVATE_VAULT_TOKEN=$(cat vault_token.json | jq -r '.auth.client_token')

cat <<EOF > cert_config.json
{"Provider": "vault", "Config": { "Address": "${PRIVATE_VAULT_ADDR}", "Token": "${PRIVATE_VAULT_TOKEN}","RootPKIPath": "connect_root", "IntermediatePKIPath": "connect_inter", "LeafCertTTL": "72h", "RotationPeriod": "2160h", "IntermediateCertTTL": "8760h", "PrivateKeyType": "rsa", "PrivateKeyBits": 2048, "Namespace": "${VAULT_NAMESPACE}" }, "ForceWithoutCrossSigning": false}
EOF

# Update Vault as CA
curl -H "X-Consul-Token: ${CONSUL_HTTP_TOKEN}" --request PUT --data @cert_config.json ${CONSUL_HTTP_ADDR}/v1/connect/ca/configuration