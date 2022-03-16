#!/bin/bash

export PGUSER=$(cd terraform && terraform output -raw database_username)
export PGPASSWORD=$(cd terraform && terraform output -raw database_password)
export PGHOST=$(cd terraform && terraform output -raw database_host)

psql -d $(cd terraform && terraform output -raw database_name) -f products.sql

export CONSUL_HTTP_ADDR=$(cd terraform && terraform output -raw consul_addr)
export CONSUL_HTTP_TOKEN=$(cd terraform && terraform output -raw consul_token)

consul acl token update -id \
		$(consul acl token list -format json |jq -r '.[] | select (.Policies[0].Name == "terminating-gateway-terminating-gateway-token") | .AccessorID') \
    	-policy-name database-write-policy -merge-policies -merge-roles -merge-service-identities